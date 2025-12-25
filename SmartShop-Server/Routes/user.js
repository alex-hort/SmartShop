const express = require('express')
const router = express.Router()
const {body} = require('express-validator')

const userController = require('../Controllers/userController')

const updateUserInfoValidator = [
  body('first_name', 'First name cannot be empty.').notEmpty(),
  body('last_name', 'Last name cannot be empty.').notEmpty(),
  body('street', 'Street cannot be empty.').notEmpty(),
  body('city', 'City cannot be empty.').notEmpty(),
  body('state', 'State cannot be empty.').notEmpty(),
  body('zip_code', 'Zip code cannot be empty.').notEmpty(),
  body('country', 'Country cannot be empty.').notEmpty()
];





router.put('/',updateUserInfoValidator, userController.updateUserProfile)

router.get('/', userController.loadUserInfo)

module.exports = router