const Joi = require('joi');
const ApiError = require('../utils/apiError');

const registerSchema = Joi.object({
  name: Joi.string().min(2).max(50).required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
  role: Joi.string().valid('customer', 'admin').optional(),
  phone: Joi.string().allow('').optional(),
  address: Joi.string().allow('').optional(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const createProductSchema = Joi.object({
  name: Joi.string().min(2).max(120).required(),
  sku: Joi.string().regex(/^[a-zA-Z0-9-_]+$/).min(3).max(30).required(),
  description: Joi.string().allow('').optional(),
  price: Joi.number().positive().required(),
  stockQuantity: Joi.number().integer().min(0).required(),
  category: Joi.string().required(),
  imageUrl: Joi.string().uri().optional(),
  lowStockThreshold: Joi.number().integer().min(0).optional(),
});

const updateProductSchema = Joi.object({
  name: Joi.string().min(2).max(120).optional(),
  sku: Joi.string().regex(/^[a-zA-Z0-9-_]+$/).min(3).max(30).optional(),
  description: Joi.string().allow('').optional(),
  price: Joi.number().positive().optional(),
  stockQuantity: Joi.number().integer().min(0).optional(),
  category: Joi.string().optional(),
  imageUrl: Joi.string().uri().optional(),
  lowStockThreshold: Joi.number().integer().min(0).optional(),
  isActive: Joi.boolean().optional(),
}).min(1);

const validate = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.body, { abortEarly: false });
  if (error) {
    const errorMessages = error.details.map((detail) => detail.message).join(', ');
    return next(new ApiError(errorMessages, 400));
  }
  next();
};

module.exports = {
  validateRegister: validate(registerSchema),
  validateLogin: validate(loginSchema),
  validateCreateProduct: validate(createProductSchema),
  validateUpdateProduct: validate(updateProductSchema),
};