const Product = require('../models/Product');
const ApiError = require('../utils/apiError');
const sendResponse = require('../utils/apiResponse');

exports.getProducts = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, search, category, inStock } = req.query;

    const query = { isActive: true };

    if (search) {
      query.name = { $regex: search, $options: 'i' };
    }

    if (category) {
      query.category = category.toLowerCase();
    }

    if (inStock === 'true') {
      query.stockQuantity = { $gt: 0 };
    }

    const skip = (parseInt(page) - 1) * parseInt(limit);
    const total = await Product.countDocuments(query);
    const products = await Product.find(query)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    return sendResponse(res, 200, 'Products retrieved successfully', {
      total,
      page: parseInt(page),
      pages: Math.ceil(total / parseInt(limit)),
      products,
    });
  } catch (error) {
    next(error);
  }
};

exports.getProductById = async (req, res, next) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product || !product.isActive) {
      return next(new ApiError('Product not found', 404));
    }

    return sendResponse(res, 200, 'Product details retrieved', { product });
  } catch (error) {
    next(error);
  }
};

exports.createProduct = async (req, res, next) => {
  try {
    const { sku } = req.body;

    const existingProduct = await Product.findOne({ sku: sku.toUpperCase() });
    if (existingProduct) {
      return next(new ApiError(`Product with SKU '${sku}' already exists`, 400));
    }

    const product = await Product.create(req.body);

    return sendResponse(res, 201, 'Product created successfully', { product });
  } catch (error) {
    next(error);
  }
};

exports.updateProduct = async (req, res, next) => {
  try {
    const product = await Product.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!product) {
      return next(new ApiError('Product not found', 404));
    }

    return sendResponse(res, 200, 'Product updated successfully', { product });
  } catch (error) {
    next(error);
  }
};

exports.deleteProduct = async (req, res, next) => {
  try {
    const product = await Product.findByIdAndUpdate(
      req.params.id,
      { isActive: false },
      { new: true }
    );

    if (!product) {
      return next(new ApiError('Product not found', 404));
    }

    return sendResponse(res, 200, 'Product deleted successfully', null);
  } catch (error) {
    next(error);
  }
};