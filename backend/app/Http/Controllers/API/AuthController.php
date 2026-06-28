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
            'email'    => 'required|email',
            'password' => 'required|string|min:6',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            $user = User::where('email', strtolower($request->email))->first();

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
}
