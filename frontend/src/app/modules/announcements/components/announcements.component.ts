import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { AuthService } from '../../../core/services/auth.service';

interface Announcement {
  id: number;
  title: string;
  body: string;
  priority: 'normal' | 'high' | 'urgent';
  audience_type?: 'all' | 'departments' | 'roles';
  is_pinned: boolean;
  is_published: boolean;
  published_at: string | null;
  scheduled_at: string | null;
  expires_at: string | null;
  category: { id: number; name: string; color?: string; icon?: string } | null;
  creator: { id: number; name: string } | null;
  has_attachment: boolean;
  attachment_name: string | null;
  created_at: string;
  reads_count?: number;
  reactions_count?: number;
  is_read?: boolean;
}

/**
 * Company announcements board. All employees read; HR/Admin create, edit,
 * delete, and manage categories.
 */
@Component({
  standalone:      false,
  selector:        'app-announcements',
  templateUrl:     './announcements.component.html',
  styleUrls:       ['./announcements.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AnnouncementsComponent implements OnInit {

  private readonly api = '/api/v1/announcements';

  isManager = false;
  loading = false;
  announcements: Announcement[] = [];
  categories: any[] = [];

  // Filters
  filterCategoryId: number | null = null;
  search = '';

  // Toast
  successMsg = '';
  errorMsg = '';

  // Announcement form
  showForm = false;
  editId: number | null = null;
  submitting = false;
  formError = '';
  form: any = this.blankForm();
  selectedFile: File | null = null;

  // Targeting data
  departments: any[] = [];
  readonly roleOptions = ['employee', 'department_manager', 'hr_staff', 'hr_manager', 'finance', 'super_admin'];

  // Engagement stats drawer
  showStats = false;
  stats: any = null;
  statsLoading = false;

  // Category manager
  showCategories = false;
  catForm: any = { name: '', color: '#2E75B6', icon: 'campaign' };
  catEditId: number | null = null;

  readonly priorities = ['normal', 'high', 'urgent'];

  constructor(
    private readonly http: HttpClient,
    private readonly auth: AuthService,
    private readonly cdr: ChangeDetectorRef,
  ) {}

  ngOnInit(): void {
    this.isManager = this.auth.hasAnyRole(['super_admin', 'hr_manager', 'hr_staff']);
    this.loadCategories();
    if (this.isManager) this.loadDepartments();
    this.load();
  }

  private blankForm(): any {
    return { category_id: null, title: '', body: '', priority: 'normal',
             audience_type: 'all', target_department_ids: [], target_roles: [],
             is_pinned: false, is_published: true, scheduled_at: '', expires_at: '' };
  }

  loadDepartments(): void {
    this.http.get<any>('/api/v1/departments').subscribe({
      next: r => { this.departments = Array.isArray(r) ? r : (r?.data || []); this.cdr.markForCheck(); },
      error: () => {},
    });
  }

  loadCategories(): void {
    this.http.get<any>(`${this.api}/categories`).subscribe({
      next: r => { this.categories = r?.categories || []; this.cdr.markForCheck(); },
      error: () => {},
    });
  }

  load(): void {
    this.loading = true;
    const params: any = {};
    if (this.filterCategoryId) params.category_id = this.filterCategoryId;
    if (this.search.trim()) params.search = this.search.trim();

    this.http.get<any>(this.api, { params }).subscribe({
      next: r => { this.announcements = r?.data || []; this.loading = false; this.cdr.markForCheck(); },
      error: () => { this.loading = false; this.cdr.markForCheck(); },
    });
  }

  onFilterChange(): void { this.load(); }

  // ── Announcement form ───────────────────────────────────────────────────

  openForm(a?: Announcement): void {
    this.formError = '';
    this.selectedFile = null;
    if (a) {
      this.editId = a.id;
      this.form = {
        category_id: a.category?.id ?? null, title: a.title, body: a.body,
        priority: a.priority, audience_type: a.audience_type ?? 'all',
        target_department_ids: (a as any).target_department_ids ?? [],
        target_roles: (a as any).target_roles ?? [],
        is_pinned: a.is_pinned, is_published: a.is_published,
        scheduled_at: a.scheduled_at ? a.scheduled_at.substring(0, 16) : '',
        expires_at: a.expires_at ?? '',
      };
    } else {
      this.editId = null;
      this.form = this.blankForm();
    }
    this.showForm = true;
    this.cdr.markForCheck();
  }

  closeForm(): void { this.showForm = false; this.cdr.markForCheck(); }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0] ?? null;
    if (file && file.size > 10 * 1024 * 1024) {
      this.formError = 'File must be 10 MB or smaller.';
      input.value = ''; this.cdr.markForCheck(); return;
    }
    this.selectedFile = file;
    this.cdr.markForCheck();
  }

  saveAnnouncement(): void {
    if (!this.form.title?.trim() || !this.form.body?.trim()) {
      this.formError = 'Title and body are required.';
      this.cdr.markForCheck();
      return;
    }
    this.submitting = true;
    this.formError = '';

    const fd = new FormData();
    fd.append('title', this.form.title);
    fd.append('body', this.form.body);
    fd.append('priority', this.form.priority);
    fd.append('audience_type', this.form.audience_type || 'all');
    fd.append('is_pinned', this.form.is_pinned ? '1' : '0');
    fd.append('is_published', this.form.is_published ? '1' : '0');
    if (this.form.category_id) fd.append('category_id', String(this.form.category_id));
    if (this.form.audience_type === 'departments' && this.form.target_department_ids?.length) {
      fd.append('target_department_ids', JSON.stringify(this.form.target_department_ids));
    }
    if (this.form.audience_type === 'roles' && this.form.target_roles?.length) {
      fd.append('target_roles', JSON.stringify(this.form.target_roles));
    }
    if (this.form.scheduled_at) fd.append('scheduled_at', this.form.scheduled_at);
    if (this.form.expires_at) fd.append('expires_at', this.form.expires_at);
    if (this.selectedFile) fd.append('attachment', this.selectedFile);
    // Laravel needs _method for multipart PUT.
    if (this.editId) fd.append('_method', 'PUT');

    const url = this.editId ? `${this.api}/${this.editId}` : this.api;
    this.http.post<any>(url, fd).subscribe({
      next: () => {
        this.submitting = false;
        this.showForm = false;
        this.toast(this.editId ? 'Announcement updated.' : 'Announcement published.');
        this.load();
      },
      error: err => {
        this.submitting = false;
        this.formError = this.firstError(err) || 'Save failed.';
        this.cdr.markForCheck();
      },
    });
  }

  deleteAnnouncement(a: Announcement): void {
    if (!confirm(`Delete "${a.title}"?`)) return;
    this.http.delete(`${this.api}/${a.id}`).subscribe({
      next: () => { this.toast('Announcement deleted.'); this.load(); },
      error: err => this.toast(this.firstError(err) || 'Delete failed.'),
    });
  }

  downloadAttachment(a: Announcement): void {
    window.open(`${this.api}/${a.id}/attachment`, '_blank');
  }

  /** Toggle a 👍 reaction and update the local count optimistically. */
  toggleReaction(a: Announcement): void {
    this.http.post<any>(`${this.api}/${a.id}/react`, { emoji: '👍' }).subscribe({
      next: r => { a.reactions_count = r?.count ?? a.reactions_count; this.cdr.markForCheck(); },
      error: () => {},
    });
  }

  /** Mark an announcement as read (called when expanding/opening). */
  markRead(a: Announcement): void {
    if (a.is_read) return;
    this.http.post<any>(`${this.api}/${a.id}/read`, {}).subscribe({
      next: () => { a.is_read = true; a.reads_count = (a.reads_count ?? 0) + 1; this.cdr.markForCheck(); },
      error: () => {},
    });
  }

  // ── Engagement stats (HR) ───────────────────────────────────────────────

  openStats(a: Announcement): void {
    this.showStats = true;
    this.stats = null;
    this.statsLoading = true;
    this.cdr.markForCheck();
    this.http.get<any>(`${this.api}/${a.id}/stats`).subscribe({
      next: r => { this.stats = r; this.statsLoading = false; this.cdr.markForCheck(); },
      error: () => { this.statsLoading = false; this.cdr.markForCheck(); },
    });
  }

  closeStats(): void { this.showStats = false; this.stats = null; this.cdr.markForCheck(); }

  /** Toggle a department id in the targeting multi-select. */
  toggleDept(id: number): void {
    const arr = this.form.target_department_ids as number[];
    const i = arr.indexOf(id);
    if (i >= 0) arr.splice(i, 1); else arr.push(id);
    this.cdr.markForCheck();
  }

  /** Toggle a role in the targeting multi-select. */
  toggleRole(role: string): void {
    const arr = this.form.target_roles as string[];
    const i = arr.indexOf(role);
    if (i >= 0) arr.splice(i, 1); else arr.push(role);
    this.cdr.markForCheck();
  }

  // ── Category manager ────────────────────────────────────────────────────

  openCategories(): void { this.showCategories = true; this.resetCatForm(); this.cdr.markForCheck(); }
  closeCategories(): void { this.showCategories = false; this.cdr.markForCheck(); }
  resetCatForm(): void { this.catEditId = null; this.catForm = { name: '', color: '#2E75B6', icon: 'campaign' }; }

  editCategory(c: any): void {
    this.catEditId = c.id;
    this.catForm = { name: c.name, color: c.color || '#2E75B6', icon: c.icon || 'campaign' };
    this.cdr.markForCheck();
  }

  saveCategory(): void {
    if (!this.catForm.name?.trim()) { this.errorMsg = 'Category name is required.'; this.cdr.markForCheck(); return; }
    const req = this.catEditId
      ? this.http.put<any>(`${this.api}/categories/${this.catEditId}`, this.catForm)
      : this.http.post<any>(`${this.api}/categories`, this.catForm);
    req.subscribe({
      next: () => { this.resetCatForm(); this.loadCategories(); this.toast('Category saved.'); },
      error: err => this.toast(this.firstError(err) || 'Save failed.'),
    });
  }

  deleteCategory(c: any): void {
    if (!confirm(`Delete category "${c.name}"? Announcements keep their content but lose this category.`)) return;
    this.http.delete(`${this.api}/categories/${c.id}`).subscribe({
      next: () => { this.loadCategories(); this.load(); this.toast('Category deleted.'); },
      error: err => this.toast(this.firstError(err) || 'Delete failed.'),
    });
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  private toast(msg: string): void {
    this.successMsg = msg; this.cdr.markForCheck();
    setTimeout(() => { this.successMsg = ''; this.cdr.markForCheck(); }, 3500);
  }

  private firstError(err: any): string {
    if (err?.error?.errors) {
      const first = Object.values(err.error.errors)[0];
      if (Array.isArray(first) && first.length) return first[0] as string;
    }
    return err?.error?.message || '';
  }
}
