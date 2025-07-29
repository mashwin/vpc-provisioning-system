# VPC Provisioning System API

This REST API allows users to sign up, authenticate using AWS Cognito, and securely provision AWS VPCs. All VPC-related operations are protected by a custom Lambda authorizer that verifies JWT access tokens issued by Cognito.

---

## Authentication Endpoints (AWS Cognito)

### `POST /signup`

Registers a new user with AWS Cognito.

- **Request Body:**

```json
{
  "username": "user@example.com",
  "password": "Test@123#"
}
```

- **Response:**

```json
{
  "message": "Signup successful. Please confirm your email."
}
```

### `POST /confirm`

Confirms the new user with AWS Cognito.

- **Request Body:**

```json
{
  "email": "user@example.com",
  "code": "1234"
}
```

- **Response:**

```json
{
  "message": "Signup successful. Please confirm your email."
}
```

### `POST /login`

Authenticates the newly registered user and returns JWT tokens from Cognito.

- **Request Body:**

```json
{
  "username": "user@example.com",
  "password": "Test@123#"
}
```

- **Response:**

```json
{
  "message": "Login successful",
  "access_token": "eyJraWQiOiJUUXZcL1pDc..."
}
```

### `POST /createvpc`

Creates a new vpc and subnet with the specified configuration

- **Request Body:**

```json
{}
```

### headers

### Authorization: <access_token>

- **Response:**

```json
{
  "message": "VPC created successfully.",
  "vpcId": "vpc-123abc"
}
```

### `GET /vpcs/vpc-1234`

Fetches VPC data from DynamoDB by VPC ID

- **Response:**

```json
{
  "vpc_id": "vpc-025c9a7c44c3b0929",
  "subnet_id": "subnet-093264317d156f87c",
  "region": "us-east-1"
}
```
