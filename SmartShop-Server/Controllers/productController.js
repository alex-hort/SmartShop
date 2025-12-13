
const models = require('../models')
const multer = require('multer')
const path = require('path')
const {validationResult} = require('express-validator')

//configure  multer for file uploads

const storage = multer.diskStorage({
    destination: function(req, file, cb){
        cb(null, 'uploads/')
    },
    filename: function(req, file, cb){
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname))
    }
})

//setting up multer for image uploads
const uploadImage = multer({
    storage: storage,
    limits: {fileSize: 1024 * 1024 * 5}, //5MB limit
    fileFilter: function(req, file, cb){
        const filetypes = /jpeg|jpg|png/;
        const mimetype = filetypes.test(file.mimetype)
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase())

        if(mimetype && extname){
            return cb(null, true)
        } else {
            cb('Error: Images only!')
        }
    }

}).single ('image')


exports.upload = async (req, res) => {
    uploadImage (req, res, function(err){
        if(err){
            return res.status(400).json({message: err, success: false})
        }
        if(!req.file){
            return res.status(400).json({message: 'No file uploaded', success: false})
        }
        const baseUrl = `${req.protocol}://${req.get('host')}`
        const filePath = `/api/uploads/${req.file.filename}`
        const downloadUrl = `${baseUrl}${filePath}`

        res.json({message: 'File uploaded successfully',  downloadUrl: downloadUrl, success: true})
    })
}


//api/products  - GET
exports.getAllProducts = async (req, res) => {
    const products = await models.Product.findAll()
    res.json(products);
}

//api/products/user/6
exports.getMyProducts = async (req, res) => {

    try{
        const userId = req.params.userId
        const products = await models.Product.findAll({
            where: {
                user_id: userId
            }
        })
        res.json(products)
    } catch (error) {
        res.status(500).json({message: 'Error retrieving products', success: false})
    }

}


//api/products - POST
exports.create = async (req, res) => {
 
    const errors = validationResult(req)
    if(!errors.isEmpty()){
        const msg = errors.array().map((e) => e.msg).join(', ')
        return res.status(422).json({message: msg, succeess: false})
    }

    const {name, description, price, photo_url, user_id} = req.body

    try {
    const newProduct = await models.Product.create({
        name: name,
        description: description,
        price: price,
        photo_url: photo_url,
        user_id: user_id

}) 
    res.status(201).json({message: 'Product created successfully', success: true, product: newProduct})

    } catch (error) {
        res.status(500).json({message: 'Internal server error', success: false})
    }

}