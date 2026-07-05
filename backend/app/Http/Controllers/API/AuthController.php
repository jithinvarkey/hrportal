<?php

declare(strict_types=1);

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email'    => 'required_without:login|string|max:255',
            'login'    => 'nullable|string|max:255',
            'password' => 'required|string|min:6',
        ]);

        $user = $this->userForLogin((string) ($request->input('login') ?: $request->input('email')));

        if (
            !$user ||
            !Auth::attempt(['email' => $user->email, 'password' => $request->password])
        ) {
            if (!$user || !$this->attemptLegacyMd5Login($user, $request->password)) {
                throw ValidationException::withMessages([
                    'email' => ['The provided credentials are incorrect.'],
                ]);
            }

            Auth::login($user);
        }

        $user  = $request->user();
        $token = $user->createToken('hrms-token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user'  => $this->userPayload($user),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        if ($request->user()) {

        $token = $request->user()->currentAccessToken();

        if ($token && method_exists($token, 'delete')) {
            $token->delete();
        }
    }

    return response()->json([
        'message' => 'Logged out successfully.'
    ]);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json(['user' => $this->userPayload($request->user())]);
    }

    public function changePassword(Request $request): JsonResponse
    {
        $request->validate([
            'current_password' => 'required',
            'password'         => 'required|min:8|confirmed',
        ]);

        if (!Hash::check($request->current_password, $request->user()->password)) {
            throw ValidationException::withMessages([
                'current_password' => ['Current password is incorrect.'],
            ]);
        }

        $request->user()->update(['password' => Hash::make($request->password)]);

        return response()->json(['message' => 'Password changed successfully']);
    }

    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);
        $status = Password::sendResetLink($request->only('email'));
        return response()->json(['message' => __($status)]);
    }

    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'token'    => 'required',
            'email'    => 'required|email',
            'password' => 'required|min:8|confirmed',
        ]);

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function (User $user, string $password): void {
                $user->forceFill(['password' => Hash::make($password)])->save();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json(['message' => 'Password has been reset successfully.']);
        }

        throw ValidationException::withMessages(['email' => [__($status)]]);
    }

    protected function userPayload(User $user): array
    {
        $user->load('employee.department', 'employee.designation', 'roles');

        return [
            'id'          => $user->id,
            'name'        => $user->name,
            'email'       => $user->email,
            'roles'       => $user->getRoleNames()->values()->toArray(),
            'permissions' => $user->getAllPermissions()->pluck('name')->values()->toArray(),
            'employee'    => $user->employee ? [
                'id'         => $user->employee->id,
                'code'       => $user->employee->employee_code,
                'full_name'  => $user->employee->full_name,
                'avatar_url' => $user->employee->avatar_url,
                'department' => optional($user->employee->department)->name,
                'departmentId'=>optional($user->employee)->department_id,
                'designation' => optional($user->employee->designation)->title ?? optional($user->employee->designation)->name,
                'designationId'=>optional($user->employee)->designation_id,
            ] : null,
        ];
    }

    private function attemptLegacyMd5Login(User $user, string $password): bool
    {
        $legacyHash = strtolower((string) $user->legacy_password_md5);

        if ($legacyHash === '' || !hash_equals($legacyHash, md5($password))) {
            return false;
        }

        $user->forceFill([
            'password' => Hash::make($password),
            'legacy_password_md5' => null,
        ])->save();

        return true;
    }

    private function userForLogin(string $login): ?User
    {
        $login = trim($login);

        if ($login === '') {
            return null;
        }

        $employeeCodeCandidates = $this->employeeCodeCandidates($login);
        $email = strtolower($login);

        return User::query()
            ->whereRaw('LOWER(email) = ?', [$email])
            ->orWhereHas('employee', function ($query) use ($employeeCodeCandidates) {
                $query->whereIn('employee_code', $employeeCodeCandidates);
            })
            ->with('employee')
            ->first();
    }

    /**
     * Accept both migrated codes like EMP182 and padded seeded codes like EMP0001.
     */
    private function employeeCodeCandidates(string $value): array
    {
        $value = strtoupper(preg_replace('/[^A-Za-z0-9]/', '', trim($value)) ?? '');

        if ($value === '') {
            return [];
        }

        $withoutPrefix = str_starts_with($value, 'EMP') ? substr($value, 3) : $value;
        $numericPart = ltrim($withoutPrefix, '0');
        $numericPart = $numericPart === '' ? '0' : $numericPart;

        return array_values(array_unique(array_filter([
            $value,
            str_starts_with($value, 'EMP') ? $value : 'EMP' . $value,
            'EMP' . $withoutPrefix,
            ctype_digit($withoutPrefix) ? 'EMP' . str_pad($numericPart, 4, '0', STR_PAD_LEFT) : null,
        ])));
    }
}
