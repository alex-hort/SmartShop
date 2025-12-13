const express = require('express');
const router = express.Router();
const productController = require('../Controllers/productController');
const { body } = require('express-validator');
const { route } = require('./auth');


const productValidator = [
    body('name','Namee cannot be empty').not().notEmpty(),
    body('description','Description cannot be empty').not().notEmpty(),
    body('price','Price must be a number').isNumeric(),
    body('photo_url','Photo URL cannot be empty').not().notEmpty(),
]
// api/products  - GET
router.get('/', productController.getAllProducts);
router.post('/', productValidator, productController.create);
///api/products/user/6
router.get('/user/:userId', productController.getMyProducts);

router.post('/upload', productController.upload);

module.exports = router;