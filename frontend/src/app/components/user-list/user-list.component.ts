import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { UserService } from '../../services/user.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-user-list',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  template: `
    <div class="fade-in">
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="text-gradient mb-3">
            <i class="fas fa-users"></i>
            User Management
          </h1>
          <p class="lead">Manage all users in the system</p>
        </div>
      </div>

      <!-- Search and Actions -->
      <div class="row mb-4">
        <div class="col-md-8">
          <div class="input-group">
            <span class="input-group-text">
              <i class="fas fa-search"></i>
            </span>
            <input type="text" class="form-control" placeholder="Search users by name..." 
                   [(ngModel)]="searchTerm" (keyup)="searchUsers()">
          </div>
        </div>
        <div class="col-md-4 text-end">
          <a routerLink="/users/new" class="btn btn-success">
            <i class="fas fa-plus"></i>
            Add New User
          </a>
          <button class="btn btn-outline-primary ms-2" (click)="loadUsers()" [disabled]="loading">
            <i class="fas fa-sync" [class.fa-spin]="loading"></i>
            Refresh
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div *ngIf="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div class="mt-2">Loading users...</div>
      </div>

      <!-- Error State -->
      <div *ngIf="error && !loading" class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-triangle"></i>
        {{ error }}
      </div>

      <!-- Users Table -->
      <div *ngIf="!loading && !error" class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">
            <i class="fas fa-table"></i>
            Users ({{ users.length }})
          </h5>
          <small class="text-muted">Total: {{ users.length }} users</small>
        </div>
        <div class="card-body p-0">
          <div *ngIf="users.length === 0" class="text-center py-5">
            <i class="fas fa-users fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">No users found</h5>
            <p class="text-muted">Get started by adding a new user.</p>
            <a routerLink="/users/new" class="btn btn-primary">
              <i class="fas fa-plus"></i>
              Add First User
            </a>
          </div>

          <div *ngIf="users.length > 0" class="table-responsive">
            <table class="table table-hover mb-0">
              <thead class="table-light">
                <tr>
                  <th scope="col">#</th>
                  <th scope="col">Name</th>
                  <th scope="col">Email</th>
                  <th scope="col">Department</th>
                  <th scope="col" class="text-center">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr *ngFor="let user of users; let i = index">
                  <th scope="row">{{ user.id }}</th>
                  <td>
                    <i class="fas fa-user text-primary me-2"></i>
                    {{ user.name }}
                  </td>
                  <td>
                    <i class="fas fa-envelope text-info me-2"></i>
                    {{ user.email }}
                  </td>
                  <td>
                    <span class="badge bg-secondary">{{ user.department }}</span>
                  </td>
                  <td class="text-center">
                    <div class="btn-group" role="group">
                      <a [routerLink]="['/users/edit', user.id]" class="btn btn-sm btn-outline-primary" title="Edit">
                        <i class="fas fa-edit"></i>
                      </a>
                      <button class="btn btn-sm btn-outline-danger" 
                              (click)="deleteUser(user)" 
                              [disabled]="deleting === user.id" 
                              title="Delete">
                        <i class="fas fa-trash" [class.fa-spin]="deleting === user.id"></i>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" *ngIf="userToDelete">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              <i class="fas fa-exclamation-triangle text-warning"></i>
              Confirm Delete
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <p>Are you sure you want to delete user <strong>{{ userToDelete.name }}</strong>?</p>
            <p class="text-muted">This action cannot be undone.</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-danger" (click)="confirmDelete()">
              <i class="fas fa-trash"></i>
              Delete User
            </button>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .table th {
      font-weight: 600;
      border-bottom: 2px solid #dee2e6;
    }
    
    .table tbody tr:hover {
      background-color: #f8f9fa;
    }
    
    .btn-group .btn {
      margin: 0 2px;
    }
    
    .badge {
      font-size: 0.75em;
    }
    
    .fade-in {
      animation: fadeIn 0.5s ease-in;
    }
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    .text-gradient {
      background: linear-gradient(135deg, #007bff, #0056b3);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  `]
})
export class UserListComponent implements OnInit {
  users: User[] = [];
  loading = false;
  error = '';
  searchTerm = '';
  userToDelete: User | null = null;
  deleting: number | null = null;

  constructor(private userService: UserService) { }

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.loading = true;
    this.error = '';
    
    this.userService.getAllUsers().subscribe({
      next: (users) => {
        this.users = users;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error loading users. Please try again.';
        this.loading = false;
        console.error('Error loading users:', error);
      }
    });
  }

  searchUsers(): void {
    if (this.searchTerm.trim() === '') {
      this.loadUsers();
      return;
    }

    this.loading = true;
    this.userService.searchUsersByName(this.searchTerm).subscribe({
      next: (users) => {
        this.users = users;
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error searching users. Please try again.';
        this.loading = false;
        console.error('Error searching users:', error);
      }
    });
  }

  deleteUser(user: User): void {
    this.userToDelete = user;
    // In a real app, you'd use a modal service here
    // For now, we'll show a confirm dialog
    if (confirm(`Are you sure you want to delete ${user.name}?`)) {
      this.confirmDelete();
    }
  }

  confirmDelete(): void {
    if (!this.userToDelete || !this.userToDelete.id) return;

    this.deleting = this.userToDelete.id;
    
    this.userService.deleteUser(this.userToDelete.id).subscribe({
      next: () => {
        this.users = this.users.filter(u => u.id !== this.userToDelete!.id);
        this.userToDelete = null;
        this.deleting = null;
      },
      error: (error) => {
        this.error = 'Error deleting user. Please try again.';
        this.deleting = null;
        console.error('Error deleting user:', error);
      }
    });
  }
}