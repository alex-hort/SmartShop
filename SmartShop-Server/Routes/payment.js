const express = require('express');
const router = express.Router();


const paymentController = require('../Controllers/paymentController');

router.post('/create-payment-intent', paymentController.createPaymentIntent);

module.exports = router;