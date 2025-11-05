import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="fade-in">
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="text-gradient mb-3">
            <i class="fas fa-tachometer-alt"></i>
            Dashboard
          </h1>
          <p class="lead">Welcome to the Fargate Spring Boot + Angular Application</p>
        </div>
      </div>

      <!-- API Health Status -->
      <div class="row mb-4">
        <div class="col-md-12">
          <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
              <h5 class="mb-0">
                <i class="fas fa-heartbeat text-success"></i>
                API Health Status
              </h5>
              <button class="btn btn-sm btn-outline-primary" (click)="checkHealth()" [disabled]="healthLoading">
                <i class="fas fa-sync" [class.fa-spin]="healthLoading"></i>
                Refresh
              </button>
            </div>
            <div class="card-body">
              <div *ngIf="healthLoading" class="text-center">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">Loading...</span>
                </div>
              </div>
              <div *ngIf="!healthLoading && healthStatus" class="alert alert-success" role="alert">
                <i class="fas fa-check-circle"></i>
                {{ healthStatus }}
              </div>
              <div *ngIf="!healthLoading && healthError" class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i>
                {{ healthError }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Statistics Cards -->
      <div class="row mb-4">
        <div class="col-lg-4 col-md-6 mb-3">
          <div class="card text-center">
            <div class="card-body">
              <div class="text-primary mb-3">
                <i class="fas fa-users fa-3x"></i>
              </div>
              <h2 class="card-title">{{ totalUsers }}</h2>
              <p class="card-text text-muted">Total Users</p>
              <a routerLink="/users" class="btn btn-primary">
                <i class="fas fa-eye"></i>
                View All
              </a>
            </div>
          </div>
        </div>

        <div class="col-lg-4 col-md-6 mb-3">
          <div class="card text-center">
            <div class="card-body">
              <div class="text-success mb-3">
                <i class="fas fa-server fa-3x"></i>
              </div>
              <h2 class="card-title">AWS</h2>
              <p class="card-text text-muted">Fargate Container</p>
              <span class="badge bg-success">Running</span>
            </div>
          </div>
        </div>

        <div class="col-lg-4 col-md-6 mb-3">
          <div class="card text-center">
            <div class="card-body">
              <div class="text-info mb-3">
                <i class="fas fa-database fa-3x"></i>
              </div>
              <h2 class="card-title">RDS</h2>
              <p class="card-text text-muted">MySQL Database</p>
              <span class="badge bg-info">Connected</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="row">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">
                <i class="fas fa-bolt"></i>
                Quick Actions
              </h5>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-4 mb-3">
                  <a routerLink="/users/new" class="btn btn-success w-100">
                    <i class="fas fa-user-plus"></i>
                    Add New User
                  </a>
                </div>
                <div class="col-md-4 mb-3">
                  <a routerLink="/users" class="btn btn-info w-100">
                    <i class="fas fa-list"></i>
                    Manage Users
                  </a>
                </div>
                <div class="col-md-4 mb-3">
                  <button class="btn btn-primary w-100" (click)="refreshData()">
                    <i class="fas fa-sync" [class.fa-spin]="loading"></i>
                    Refresh Data
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Architecture Info -->
      <div class="row mt-4">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">
                <i class="fas fa-sitemap"></i>
                Architecture Overview
              </h5>
            </div>
            <div class="card-body">
              <div class="row text-center">
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fab fa-gitlab fa-2x text-warning"></i>
                    <div class="mt-2">
                      <small class="fw-bold">GitLab CI/CD</small>
                    </div>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fas fa-tools fa-2x text-info"></i>
                    <div class="mt-2">
                      <small class="fw-bold">Terraform</small>
                    </div>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fab fa-aws fa-2x text-warning"></i>
                    <div class="mt-2">
                      <small class="fw-bold">AWS Fargate</small>
                    </div>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fas fa-leaf fa-2x text-success"></i>
                    <div class="mt-2">
                      <small class="fw-bold">Spring Boot</small>
                    </div>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fab fa-angular fa-2x text-danger"></i>
                    <div class="mt-2">
                      <small class="fw-bold">Angular</small>
                    </div>
                  </div>
                </div>
                <div class="col-md-2">
                  <div class="mb-3">
                    <i class="fas fa-shield-alt fa-2x text-primary"></i>
                    <div class="mt-2">
                      <small class="fw-bold">CloudFront + WAF</small>
                    </div>
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
    .card {
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
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
  `]
})
export class DashboardComponent implements OnInit {
  totalUsers = 0;
  loading = false;
  healthLoading = false;
  healthStatus = '';
  healthError = '';

  constructor(private userService: UserService) { }

  ngOnInit(): void {
    this.loadData();
    this.checkHealth();
  }

  loadData(): void {
    this.loading = true;
    this.userService.getUserCount().subscribe({
      next: (count) => {
        this.totalUsers = count;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading user count:', error);
        this.loading = false;
      }
    });
  }

  checkHealth(): void {
    this.healthLoading = true;
    this.healthStatus = '';
    this.healthError = '';
    
    this.userService.healthCheck().subscribe({
      next: (response) => {
        this.healthStatus = response;
        this.healthLoading = false;
      },
      error: (error) => {
        this.healthError = 'API is not responding. Please check the backend service.';
        this.healthLoading = false;
        console.error('Health check failed:', error);
      }
    });
  }

  refreshData(): void {
    this.loadData();
    this.checkHealth();
  }
}