const express = require('express');
const {
  createInvoice,
  getInvoices,
  getInvoiceById,
  cancelInvoice,
} = require('../controllers/invoiceController');
const { protect } = require('../middlewares/auth');

const router = express.Router();

router.use(protect);

router.post('/', createInvoice);
router.get('/', getInvoices);
router.get('/:id', getInvoiceById);
router.put('/:id/cancel', cancelInvoice);

module.exports = router;