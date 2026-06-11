import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { HttpClient } from '@angular/common/http';

/**
 * Public "Forgot Password" screen.
 *
 * Collects the account email and asks the backend to email a password-reset
 * link (POST /api/v1/auth/forgot-password). To avoid leaking which emails are
 * registered, the success state is shown regardless of whether the address
 * exists — matching Laravel's password-broker behaviour.
 */
@Component({
  standalone: false,
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./login.component.scss'],
})
export class ForgotPasswordComponent implements OnInit {
  form!: FormGroup;
  loading = false;
  sent = false;
  errorMsg = '';

  constructor(private fb: FormBuilder, private http: HttpClient) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
    });
  }

  /** Submit the email and request a reset link. */
  onSubmit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMsg = '';

    this.http.post<any>('/api/v1/auth/forgot-password', this.form.value).subscribe({
      next: () => {
        this.loading = false;
        this.sent = true;
      },
      error: (err) => {
        this.loading = false;
        // Validation errors (e.g. malformed email) are worth surfacing;
        // otherwise still show the neutral "sent" state.
        if (err?.status === 422) {
          this.errorMsg = err?.error?.message ?? 'Please enter a valid email address.';
        } else {
          this.sent = true;
        }
      },
    });
  }
}
