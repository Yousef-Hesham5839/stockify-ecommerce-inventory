const Invoice = require('../models/Invoice');
const Product = require('../models/Product');
const ApiError = require('../utils/apiError');
const sendResponse = require('../utils/apiResponse');

const generateInvoiceNumber = () => {
  const timestamp = Date.now().toString().slice(-6);
  const random = Math.floor(1000 + Math.random() * 9000);
  return `INV-${timestamp}-${random}`;
};

exports.createInvoice = async (req, res, next) => {
  try {
    const { items, shippingAddress, paymentMethod } = req.body;

    if (!items || items.length === 0) {
      return next(new ApiError('No items provided in order', 400));
    }

    let subtotal = 0;
    const processedItems = [];
    const stockDeductions = [];

    for (const item of items) {
      const product = await Product.findById(item.productId);

      if (!product || !product.isActive) {
        return next(new ApiError(`Product not found or inactive: ${item.productId}`, 404));
      }

      if (product.stockQuantity < item.quantity) {
        return next(
          new ApiError(
            `Insufficient stock for '${product.name}'. Available: ${product.stockQuantity}, Requested: ${item.quantity}`,
            400
          )
        );
      }

      const itemTotal = Number((product.price * item.quantity).toFixed(2));
      subtotal += itemTotal;

      processedItems.push({
        product: product._id,
        name: product.name,
        sku: product.sku,
        unitPrice: product.price,
        quantity: item.quantity,
        total: itemTotal,
      });

      stockDeductions.push({
        productId: product._id,
        quantity: item.quantity,
      });
    }

    subtotal = Number(subtotal.toFixed(2));
    const taxAmount = Number((subtotal * 0.14).toFixed(2));
    const totalAmount = Number((subtotal + taxAmount).toFixed(2));

    for (const deduction of stockDeductions) {
      await Product.findByIdAndUpdate(deduction.productId, {
        $inc: { stockQuantity: -deduction.quantity },
      });
    }

    const invoice = await Invoice.create({
      invoiceNumber: generateInvoiceNumber(),
      user: req.user._id,
      items: processedItems,
      subtotal,
      taxAmount,
      totalAmount,
      shippingAddress: shippingAddress || req.user.address || 'Address not specified',
      paymentMethod: paymentMethod || 'CASH_ON_DELIVERY',
      status: 'PENDING',
    });

    return sendResponse(res, 201, 'Invoice created and stock reserved successfully', {
      invoice,
    });
  } catch (error) {
    next(error);
  }
};

exports.getInvoices = async (req, res, next) => {
  try {
    const filter = {};

    if (req.user.role !== 'admin') {
      filter.user = req.user._id;
    }

    const invoices = await Invoice.find(filter)
      .populate('user', 'name email phone')
      .sort({ createdAt: -1 });

    return sendResponse(res, 200, 'Invoices retrieved successfully', {
      count: invoices.length,
      invoices,
    });
  } catch (error) {
    next(error);
  }
};

exports.getInvoiceById = async (req, res, next) => {
  try {
    const invoice = await Invoice.findById(req.params.id).populate('user', 'name email phone');

    if (!invoice) {
      return next(new ApiError('Invoice not found', 404));
    }

    if (req.user.role !== 'admin' && invoice.user._id.toString() !== req.user._id.toString()) {
      return next(new ApiError('Not authorized to view this invoice', 403));
    }

    return sendResponse(res, 200, 'Invoice details retrieved', { invoice });
  } catch (error) {
    next(error);
  }
};

exports.cancelInvoice = async (req, res, next) => {
  try {
    const invoice = await Invoice.findById(req.params.id);

    if (!invoice) {
      return next(new ApiError('Invoice not found', 404));
    }

    if (req.user.role !== 'admin' && invoice.user.toString() !== req.user._id.toString()) {
      return next(new ApiError('Not authorized to cancel this invoice', 403));
    }

    if (invoice.status === 'CANCELLED') {
      return next(new ApiError('Invoice is already cancelled', 400));
    }

    for (const item of invoice.items) {
      await Product.findByIdAndUpdate(item.product, {
        $inc: { stockQuantity: item.quantity },
      });
    }

    invoice.status = 'CANCELLED';
    await invoice.save();

    return sendResponse(res, 200, 'Invoice cancelled and stock restored successfully', {
      invoice,
    });
  } catch (error) {
    next(error);
  }
};