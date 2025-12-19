const express = require('express');
const router = express.Router();
const cartController = require('../Controllers/carController');
//add item to cart
router.post('/items', cartController.addCartItem);
//load cart
router.get('/', cartController.loadCart);

//detele item from cart
router.delete('/item/:cartItemId', cartController.removeCartItem);

module.exports = router;