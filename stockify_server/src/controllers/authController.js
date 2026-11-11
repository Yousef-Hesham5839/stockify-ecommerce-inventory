const jwt = require('jsonwebtoken');
const User = require('../models/User');
const ApiError = require('../utils/apiError');
const sendResponse = require('../utils/apiResponse');

const generateToken = (userId, role) => {
  return jwt.sign({ id: userId, role }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });
};


exports.register = async (req, res, next) => {
  try {
    const { name, email, password, role, phone, address } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return next(new ApiError('Email is already registered', 400));
    }

    const user = await User.create({
      name,
      email,
      password,
      role: role || 'customer',
      phone,
      address,
    });

    const token = generateToken(user._id, user.role);

    const userData = {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      phone: user.phone,
      address: user.address,
    };

    return sendResponse(res, 201, 'User registered successfully', {
      user: userData,
      token,
    });
  } catch (error) {
    next(error);
  }
};


exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+password');
    if (!user || !(await user.comparePassword(password))) {
      return next(new ApiError('Invalid email or password', 401));
    }

    const token = generateToken(user._id, user.role);

    const userData = {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      phone: user.phone,
      address: user.address,
    };

    return sendResponse(res, 200, 'Login successful', {
      user: userData,
      token,
    });
  } catch (error) {
    next(error);
  }
};


exports.getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return next(new ApiError('User not found', 404));
    }

    return sendResponse(res, 200, 'User profile retrieved', { user });
  } catch (error) {
    next(error);
  }
};