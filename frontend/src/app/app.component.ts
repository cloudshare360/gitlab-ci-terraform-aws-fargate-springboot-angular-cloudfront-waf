import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterModule],
  template: `
    <nav class="navbar navbar-expand-lg navbar-dark">
      <div class="container">
        <a class="navbar-brand" routerLink="/">
          <i class="fas fa-cloud"></i>
          Fargate App
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <a class="nav-link" routerLink="/dashboard" routerLinkActive="active">
                <i class="fas fa-tachometer-alt"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" routerLink="/users" routerLinkActive="active">
                <i class="fas fa-users"></i> Users
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" routerLink="/users/new" routerLinkActive="active">
                <i class="fas fa-plus"></i> Add User
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <main class="container mt-4">
      <router-outlet></router-outlet>
    </main>

    <footer class="bg-light text-center py-3 mt-5">
      <div class="container">
        <small class="text-muted">
          © 2024 Fargate Angular Frontend. Powered by AWS Fargate + Spring Boot + Angular
        </small>
      </div>
    </footer>
  `,
  styles: [`
    .navbar {
      background: linear-gradient(135deg, #007bff, #0056b3) !important;
    }
    
    .nav-link {
      transition: all 0.3s ease;
    }
    
    .nav-link:hover {
      transform: translateY(-1px);
    }
    
    .nav-link.active {
      background-color: rgba(255, 255, 255, 0.2);
      border-radius: 6px;
    }
    
    main {
      min-height: calc(100vh - 200px);
    }
    
    footer {
      margin-top: auto;
    }
  `]
})
export class AppComponent {
  title = 'fargate-angular-frontend';
}