const express = require('express');
const {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');
const {
  validateCreateProduct,
  validateUpdateProduct,
} = require('../middlewares/validators');
const { protect, restrictTo } = require('../middlewares/auth');

const router = express.Router();

router.get('/', getProducts);
router.get('/:id', getProductById);

router.post('/', protect, restrictTo('admin'), validateCreateProduct, createProduct);
router.put('/:id', protect, restrictTo('admin'), validateUpdateProduct, updateProduct);
router.delete('/:id', protect, restrictTo('admin'), deleteProduct);

module.exports = router;