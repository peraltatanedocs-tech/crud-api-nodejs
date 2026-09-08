# CRUD API - Node.js, Express, MongoDB

A complete CRUD API application built with Node.js, Express, and MongoDB.

## Features

✅ **Create** - Add new users
✅ **Read** - Fetch all users or a specific user
✅ **Update** - Modify user information
✅ **Delete** - Remove users
✅ **Search** - Find users by name or email
✅ **Validation** - Input validation and error handling
✅ **CORS** - Cross-Origin Resource Sharing enabled

## Installation

### Prerequisites
- Node.js (v14 or higher)
- MongoDB (local or MongoDB Atlas)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/peraltatanedocs-tech/crud-api-nodejs.git
   cd crud-api-nodejs
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create .env file**
   ```bash
   cp .env.example .env
   ```

4. **Update .env with your MongoDB URI**
   ```
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/crud-db
   NODE_ENV=development
   ```

5. **Start the server**
   ```bash
   npm start
   # or for development with auto-reload
   npm run dev
   ```

## API Endpoints

### 1. CREATE - Add a new user
```http
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "phone": "1234567890",
  "address": "123 Main St"
}
```

### 2. READ - Get all users
```http
GET /api/users
```

### 3. READ - Get a specific user
```http
GET /api/users/:id
```

### 4. UPDATE - Modify a user
```http
PUT /api/users/:id
Content-Type: application/json

{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "age": 28
}
```

### 5. DELETE - Remove a user
```http
DELETE /api/users/:id
```

### 6. SEARCH - Find users
```http
GET /api/users/search?query=john
```

## Example Usage with cURL

### Create a user
```bash
curl -X POST http://localhost:5000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","age":30}'
```

### Get all users
```bash
curl http://localhost:5000/api/users
```

### Get specific user (replace with actual ID)
```bash
curl http://localhost:5000/api/users/USER_ID
```

### Update a user
```bash
curl -X PUT http://localhost:5000/api/users/USER_ID \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane Doe","age":28}'
```

### Delete a user
```bash
curl -X DELETE http://localhost:5000/api/users/USER_ID
```

### Search users
```bash
curl "http://localhost:5000/api/users/search?query=john"
```

## Project Structure

```
crud-api-nodejs/
├── models/
│   └── User.js              # MongoDB User schema
├── controllers/
│   └── userController.js    # Business logic for CRUD operations
├── routes/
│   └── userRoutes.js        # API route definitions
├── .env.example             # Environment variables example
├── .gitignore              # Git ignore file
├── package.json            # Project dependencies
├── server.js               # Main application file
└── README.md               # This file
```

## Technologies Used

- **Node.js** - JavaScript runtime
- **Express** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB object modeling
- **CORS** - Cross-Origin Resource Sharing
- **Dotenv** - Environment variables management

## Error Handling

The API includes comprehensive error handling:
- Input validation
- Duplicate email prevention
- Proper HTTP status codes
- Detailed error messages

## Future Enhancements

- [ ] Authentication & Authorization (JWT)
- [ ] Rate limiting
- [ ] Pagination
- [ ] Advanced filtering
- [ ] Unit tests
- [ ] API documentation (Swagger)

## License

MIT

## Author

Created by peraltatanedocs-tech
