const User = require('../models/User');

// CREATE - Add a new user
exports.createUser = async (req, res) => {
  try {
    const { name, email, age, phone, address } = req.body;

    // Validation
    if (!name || !email) {
      return res.status(400).json({ error: 'Name and email are required' });
    }

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'User with this email already exists' });
    }

    const newUser = new User({
      name,
      email,
      age,
      phone,
      address
    });

    const savedUser = await newUser.save();
    res.status(201).json({
      message: 'User created successfully',
      user: savedUser
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// READ - Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });
    res.status(200).json({
      count: users.length,
      users: users
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// READ - Get single user by ID
exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      message: 'User found',
      user: user
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// UPDATE - Update user by ID
exports.updateUser = async (req, res) => {
  try {
    const { name, email, age, phone, address } = req.body;

    // Find and update user
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      {
        name,
        email,
        age,
        phone,
        address,
        updatedAt: Date.now()
      },
      { new: true, runValidators: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      message: 'User updated successfully',
      user: updatedUser
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// DELETE - Delete user by ID
exports.deleteUser = async (req, res) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);

    if (!deletedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      message: 'User deleted successfully',
      user: deletedUser
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Search users by name or email
exports.searchUsers = async (req, res) => {
  try {
    const { query } = req.query;

    if (!query) {
      return res.status(400).json({ error: 'Search query is required' });
    }

    const users = await User.find({
      $or: [
        { name: { $regex: query, $options: 'i' } },
        { email: { $regex: query, $options: 'i' } }
      ]
    });

    res.status(200).json({
      count: users.length,
      users: users
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
