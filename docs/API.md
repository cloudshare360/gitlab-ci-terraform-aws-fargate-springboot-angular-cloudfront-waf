# 📊 API Documentation

This document provides comprehensive documentation for the Fargate Spring Boot REST API.

## 🌐 Base URL

| Environment | URL |
|-------------|-----|
| Local Development | `http://localhost:8080` |
| Staging | `https://staging-api.yourdomain.com` |
| Production | `https://api.yourdomain.com` |

## 🔐 Authentication

Currently, the API uses basic security configuration. All endpoints are publicly accessible for demonstration purposes. In production, implement proper authentication:

```http
Authorization: Bearer <jwt-token>
```

## 📋 API Endpoints

### 🏥 Health Check

#### GET /api/users/health
Check the health status of the API.

**Response**
```json
{
  "status": "API is running successfully!",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### 👥 User Management

#### GET /api/users
Retrieve all users.

**Response**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "department": "Engineering"
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane.smith@example.com",
    "department": "Marketing"
  }
]
```

#### GET /api/users/{id}
Retrieve a specific user by ID.

**Parameters**
- `id` (path): User ID

**Response**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com",
  "department": "Engineering"
}
```

**Error Response**
```json
{
  "error": "User not found",
  "status": 404,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### GET /api/users/email/{email}
Retrieve a user by email address.

**Parameters**
- `email` (path): User email address

**Response**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john.doe@example.com",
  "department": "Engineering"
}
```

#### GET /api/users/department/{department}
Retrieve users by department.

**Parameters**
- `department` (path): Department name

**Response**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "department": "Engineering"
  },
  {
    "id": 3,
    "name": "Bob Wilson",
    "email": "bob.wilson@example.com",
    "department": "Engineering"
  }
]
```

#### GET /api/users/search
Search users by name.

**Parameters**
- `name` (query): Search term for user name

**Example**
```http
GET /api/users/search?name=john
```

**Response**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "department": "Engineering"
  }
]
```

#### POST /api/users
Create a new user.

**Request Body**
```json
{
  "name": "New User",
  "email": "new.user@example.com",
  "department": "Sales"
}
```

**Response**
```json
{
  "id": 4,
  "name": "New User",
  "email": "new.user@example.com",
  "department": "Sales"
}
```

**Validation Errors**
```json
{
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email"
    },
    {
      "field": "name",
      "message": "Name must be between 2 and 50 characters"
    }
  ],
  "status": 400,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### PUT /api/users/{id}
Update an existing user.

**Parameters**
- `id` (path): User ID

**Request Body**
```json
{
  "name": "Updated Name",
  "email": "updated.email@example.com",
  "department": "Operations"
}
```

**Response**
```json
{
  "id": 1,
  "name": "Updated Name",
  "email": "updated.email@example.com",
  "department": "Operations"
}
```

#### DELETE /api/users/{id}
Delete a user.

**Parameters**
- `id` (path): User ID

**Response**
```
Status: 204 No Content
```

#### GET /api/users/count
Get the total number of users.

**Response**
```json
{
  "count": 25
}
```

## 📊 Response Codes

| Status Code | Description |
|-------------|-------------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 204 | No Content - Request successful, no content to return |
| 400 | Bad Request - Invalid request data |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error - Server error |

## 🔍 Error Handling

### Standard Error Response
```json
{
  "error": "Error message description",
  "status": 400,
  "timestamp": "2024-01-15T10:30:00Z",
  "path": "/api/users"
}
```

### Validation Error Response
```json
{
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email"
    }
  ],
  "status": 400,
  "timestamp": "2024-01-15T10:30:00Z",
  "path": "/api/users"
}
```

## 📝 Data Models

### User Model
```json
{
  "id": "number (auto-generated)",
  "name": "string (2-50 characters, required)",
  "email": "string (valid email format, required, unique)",
  "department": "string (required)"
}
```

### Departments
Available department values:
- Engineering
- Marketing
- Sales
- Human Resources
- Finance
- Operations
- Customer Support
- Product Management

## 🧪 Testing Examples

### cURL Examples

#### Get all users
```bash
curl -X GET http://localhost:8080/api/users
```

#### Create a user
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "department": "Engineering"
  }'
```

#### Update a user
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated User",
    "email": "updated@example.com",
    "department": "Marketing"
  }'
```

#### Delete a user
```bash
curl -X DELETE http://localhost:8080/api/users/1
```

### Postman Collection

You can import this Postman collection to test the API:

```json
{
  "info": {
    "name": "Fargate Spring Boot API",
    "description": "API collection for testing user management endpoints"
  },
  "item": [
    {
      "name": "Get All Users",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "{{baseUrl}}/api/users",
          "host": ["{{baseUrl}}"],
          "path": ["api", "users"]
        }
      }
    },
    {
      "name": "Create User",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"Test User\",\n  \"email\": \"test@example.com\",\n  \"department\": \"Engineering\"\n}"
        },
        "url": {
          "raw": "{{baseUrl}}/api/users",
          "host": ["{{baseUrl}}"],
          "path": ["api", "users"]
        }
      }
    }
  ],
  "variable": [
    {
      "key": "baseUrl",
      "value": "http://localhost:8080"
    }
  ]
}
```

## 📊 Performance Considerations

### Response Times
- **Target**: < 500ms for all endpoints
- **Database queries**: Optimized with proper indexing
- **Connection pooling**: Configured for high throughput

### Rate Limiting
- **Development**: No limits
- **Production**: 1000 requests/hour per IP (configurable)

### Caching
- **User data**: Cached for 5 minutes
- **Static data**: Cached for 1 hour

## 🔐 Security Features

### Input Validation
- **Email format**: Validated using regex
- **String length**: Min/max length validation
- **SQL injection**: Prevented using parameterized queries
- **XSS**: Input sanitization

### CORS Configuration
```java
@CrossOrigin(origins = "*", allowedHeaders = "*")
```

*Note: In production, configure specific origins*

### Headers
```http
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
```

## 📈 Monitoring Endpoints

### Spring Actuator Endpoints

#### GET /actuator/health
Application health status
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MySQL",
        "validationQuery": "isValid()"
      }
    }
  }
}
```

#### GET /actuator/info
Application information
```json
{
  "app": {
    "name": "Fargate Spring Boot API",
    "description": "Spring Boot REST API for AWS Fargate deployment",
    "version": "1.0.0",
    "encoding": "UTF-8",
    "java": {
      "version": "21.0.1"
    }
  }
}
```

#### GET /actuator/metrics
Application metrics
```json
{
  "names": [
    "jvm.memory.used",
    "jvm.memory.max",
    "http.server.requests",
    "jdbc.connections.active"
  ]
}
```

## 🔄 Versioning

### API Versioning Strategy
- **Current Version**: v1
- **URL Structure**: `/api/v1/users` (future versions)
- **Header**: `Accept: application/vnd.api+json;version=1`

### Backward Compatibility
- Existing endpoints remain functional
- New fields added without breaking changes
- Deprecated endpoints marked clearly

## 📚 Additional Resources

### OpenAPI/Swagger Documentation
Access interactive API documentation at:
- **Local**: http://localhost:8080/swagger-ui.html
- **Production**: https://api.yourdomain.com/swagger-ui.html

### API Client Libraries
- **Java**: Spring Boot WebClient
- **JavaScript**: Axios, Fetch API
- **Python**: Requests
- **C#**: HttpClient

### Webhook Support
Future feature for real-time notifications:
```json
{
  "event": "user.created",
  "data": {
    "id": 1,
    "name": "New User",
    "email": "new@example.com"
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

---

For more information, please refer to the [Development Guide](DEVELOPMENT.md) or contact the development team.