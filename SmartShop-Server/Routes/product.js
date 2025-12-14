const express = require('express');
const router = express.Router();
const productController = require('../Controllers/productController');
const { body , param} = require('express-validator');
const { route } = require('./auth');


const productValidator = [
    body('name','Namee cannot be empty').not().notEmpty(),
    body('description','Description cannot be empty').not().notEmpty(),
    body('price','Price must be a number').isNumeric(),
    body('photo_url','Photo URL cannot be empty').not().notEmpty(),
]


const deleteProductValidator = [
    param('productId')
    .notEmpty().withMessage('Product ID is required')
    .isNumeric().withMessage('Product ID must be a number')
]

const updateProductValidator = [
  param('productId')
    .notEmpty().withMessage('ProductId is required.')
    .isNumeric().withMessage('Product Id must be a number'),
  body('name', 'name cannot be empty.').not().isEmpty(),
  body('description', 'description cannot be empty.').not().isEmpty(),
  body('price', 'price cannot be empty.').not().isEmpty(),
  body('photo_url').notEmpty().withMessage('Photo URL cannot be empty.'),
  body('user_id').notEmpty().withMessage('User ID cannot be empty.').isNumeric().withMessage('User ID must be a number')
]


// api/products  - GET
router.get('/', productController.getAllProducts);
router.post('/', productValidator, productController.create);
///api/products/user/6
router.get('/user/:userId', productController.getMyProducts);

router.post('/upload', productController.upload);

//DELETE /api/products/34
router.delete('/:productId',deleteProductValidator, productController.deleteProduct);

//PUT 
router.put('/:productId', updateProductValidator,productController.updateProduct);

module.exports = router;