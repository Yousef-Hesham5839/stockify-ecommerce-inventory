const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const ApiError = require('./utils/apiError');
const errorHandler = require('./middlewares/errorHandler');

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}


app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok', message: 'Stockify API is running smoothly' });
});


app.use((req, res, next) => {
  next(new ApiError(`Can't find ${req.originalUrl} on this server!`, 404));
});

app.use(errorHandler);

module.exports = app;