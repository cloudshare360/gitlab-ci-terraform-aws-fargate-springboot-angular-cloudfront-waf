import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router, ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { UserService } from '../../services/user.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-user-form',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  template: `
    <div class="fade-in">
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="text-gradient mb-3">
            <i class="fas fa-user-edit"></i>
            {{ isEdit ? 'Edit User' : 'Add New User' }}
          </h1>
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a routerLink="/dashboard">Dashboard</a></li>
              <li class="breadcrumb-item"><a routerLink="/users">Users</a></li>
              <li class="breadcrumb-item active">{{ isEdit ? 'Edit' : 'Add' }}</li>
            </ol>
          </nav>
        </div>
      </div>

      <div class="row justify-content-center">
        <div class="col-lg-8">
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">
                <i class="fas fa-user"></i>
                User Information
              </h5>
            </div>
            <div class="card-body">
              <!-- Loading State -->
              <div *ngIf="loading" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">Loading...</span>
                </div>
                <div class="mt-2">Loading user data...</div>
              </div>

              <!-- Error State -->
              <div *ngIf="error && !loading" class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i>
                {{ error }}
              </div>

              <!-- Form -->
              <form *ngIf="!loading" (ngSubmit)="onSubmit()" #userForm="ngForm">
                <div class="row">
                  <div class="col-md-6 mb-3">
                    <label for="name" class="form-label">
                      <i class="fas fa-user text-primary"></i>
                      Full Name *
                    </label>
                    <input type="text" 
                           class="form-control" 
                           id="name" 
                           name="name"
                           [(ngModel)]="user.name" 
                           required 
                           minlength="2"
                           maxlength="50"
                           #name="ngModel"
                           placeholder="Enter full name">
                    <div *ngIf="name.invalid && (name.dirty || name.touched)" class="text-danger mt-1">
                      <div *ngIf="name.errors?.['required']">Name is required</div>
                      <div *ngIf="name.errors?.['minlength']">Name must be at least 2 characters</div>
                      <div *ngIf="name.errors?.['maxlength']">Name cannot exceed 50 characters</div>
                    </div>
                  </div>

                  <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">
                      <i class="fas fa-envelope text-info"></i>
                      Email Address *
                    </label>
                    <input type="email" 
                           class="form-control" 
                           id="email" 
                           name="email"
                           [(ngModel)]="user.email" 
                           required 
                           email
                           #email="ngModel"
                           placeholder="Enter email address">
                    <div *ngIf="email.invalid && (email.dirty || email.touched)" class="text-danger mt-1">
                      <div *ngIf="email.errors?.['required']">Email is required</div>
                      <div *ngIf="email.errors?.['email']">Please enter a valid email address</div>
                    </div>
                  </div>
                </div>

                <div class="row">
                  <div class="col-12 mb-3">
                    <label for="department" class="form-label">
                      <i class="fas fa-building text-success"></i>
                      Department *
                    </label>
                    <select class="form-select" 
                            id="department" 
                            name="department"
                            [(ngModel)]="user.department" 
                            required
                            #department="ngModel">
                      <option value="">Select Department</option>
                      <option value="Engineering">Engineering</option>
                      <option value="Marketing">Marketing</option>
                      <option value="Sales">Sales</option>
                      <option value="Human Resources">Human Resources</option>
                      <option value="Finance">Finance</option>
                      <option value="Operations">Operations</option>
                      <option value="Customer Support">Customer Support</option>
                      <option value="Product Management">Product Management</option>
                    </select>
                    <div *ngIf="department.invalid && (department.dirty || department.touched)" class="text-danger mt-1">
                      <div *ngIf="department.errors?.['required']">Please select a department</div>
                    </div>
                  </div>
                </div>

                <!-- Form Actions -->
                <div class="row">
                  <div class="col-12">
                    <div class="d-flex justify-content-between">
                      <a routerLink="/users" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Back to Users
                      </a>
                      <div>
                        <button type="button" 
                                class="btn btn-outline-primary me-2" 
                                (click)="resetForm()"
                                [disabled]="saving">
                          <i class="fas fa-undo"></i>
                          Reset
                        </button>
                        <button type="submit" 
                                class="btn btn-success"
                                [disabled]="userForm.invalid || saving">
                          <i class="fas fa-spinner fa-spin" *ngIf="saving"></i>
                          <i class="fas fa-save" *ngIf="!saving"></i>
                          {{ saving ? 'Saving...' : (isEdit ? 'Update User' : 'Create User') }}
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>

          <!-- Form Information Card -->
          <div class="card mt-4">
            <div class="card-header">
              <h6 class="mb-0">
                <i class="fas fa-info-circle"></i>
                Form Information
              </h6>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-4">
                  <strong>Required Fields:</strong>
                  <ul class="mt-2">
                    <li>Full Name (2-50 chars)</li>
                    <li>Valid Email Address</li>
                    <li>Department</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <strong>Form Status:</strong>
                  <div class="mt-2">
                    <span class="badge" [ngClass]="userForm?.valid ? 'bg-success' : 'bg-warning'">
                      {{ userForm?.valid ? 'Valid' : 'Invalid' }}
                    </span>
                  </div>
                </div>
                <div class="col-md-4">
                  <strong>Action:</strong>
                  <div class="mt-2">
                    <span class="badge bg-info">
                      {{ isEdit ? 'Updating Existing User' : 'Creating New User' }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .form-label {
      font-weight: 600;
      margin-bottom: 0.5rem;
    }
    
    .form-control, .form-select {
      border-radius: 8px;
      border: 1px solid #dee2e6;
      transition: all 0.3s ease;
    }
    
    .form-control:focus, .form-select:focus {
      border-color: #007bff;
      box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }
    
    .card {
      border: none;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .breadcrumb {
      background-color: transparent;
      padding: 0;
    }
    
    .breadcrumb-item a {
      text-decoration: none;
      color: #007bff;
    }
    
    .text-gradient {
      background: linear-gradient(135deg, #007bff, #0056b3);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
    
    .fade-in {
      animation: fadeIn 0.5s ease-in;
    }
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    .btn {
      border-radius: 8px;
      font-weight: 500;
      transition: all 0.3s ease;
    }
    
    .btn:hover {
      transform: translateY(-1px);
    }
  `]
})
export class UserFormComponent implements OnInit {
  user: User = {
    name: '',
    email: '',
    department: ''
  };
  
  isEdit = false;
  userId: number | null = null;
  loading = false;
  saving = false;
  error = '';

  constructor(
    private userService: UserService,
    private router: Router,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.isEdit = true;
        this.userId = +params['id'];
        this.loadUser();
      }
    });
  }

  loadUser(): void {
    if (!this.userId) return;
    
    this.loading = true;
    this.error = '';
    
    this.userService.getUserById(this.userId).subscribe({
      next: (user) => {
        this.user = user;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error loading user data. Please try again.';
        this.loading = false;
        console.error('Error loading user:', error);
      }
    });
  }

  onSubmit(): void {
    if (this.saving) return;
    
    this.saving = true;
    this.error = '';

    const userOperation = this.isEdit && this.userId
      ? this.userService.updateUser(this.userId, this.user)
      : this.userService.createUser(this.user);

    userOperation.subscribe({
      next: (savedUser) => {
        this.saving = false;
        this.router.navigate(['/users']);
      },
      error: (error) => {
        this.error = error.status === 409 
          ? 'A user with this email already exists.' 
          : 'Error saving user. Please try again.';
        this.saving = false;
        console.error('Error saving user:', error);
      }
    });
  }

  resetForm(): void {
    if (this.isEdit && this.userId) {
      this.loadUser();
    } else {
      this.user = {
        name: '',
        email: '',
        department: ''
      };
    }
    this.error = '';
  }
}