const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// CREATE - POST /api/users
router.post('/', userController.createUser);

// READ - GET all users
router.get('/', userController.getAllUsers);

// SEARCH - GET /api/users/search?query=...
router.get('/search', userController.searchUsers);

// READ - GET single user by ID
router.get('/:id', userController.getUserById);

// UPDATE - PUT /api/users/:id
router.put('/:id', userController.updateUser);

// DELETE - DELETE /api/users/:id
router.delete('/:id', userController.deleteUser);

module.exports = router;
