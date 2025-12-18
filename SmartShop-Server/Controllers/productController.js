
const models = require('../models')
const multer = require('multer')
const path = require('path')
const {validationResult} = require('express-validator')
const e = require('express')
const { error } = require('console')
const { get } = require('http')
const { getFilenameFromUrl, deleteFile } = require('../Utils/fileUtils')

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

exports.deleteProduct = async (req, res) => {
    
    const errors = validationResult(req)

    if(!errors.isEmpty()){
        const msg = errors.array().map((e) => e.msg).join(', ')
        return res.status(422).json({message: msg, succeess: false})
    }

    const productId = req.params.productId

   try {
    const product = await models.Product.findByPk(productId)
    if(!product){
        return res.status(404).json({message: 'Product not found', success: false})
    }

    const fileName = getFilenameFromUrl(product.photo_url)


    //delete product
    const result = await models.Product.destroy({
        where: {
            id: productId
        }
    })
    if(result == 0){

        return res.status(500).json({message: 'Product not found', success: false})

    }

    //delete associated file
    await deleteFile (fileName)


    return res.json({message: `Product deleted successfully ${productId}`, success: true})
    
   }catch (error) {
    return res.status(500).json({message: 'Error deleting product', success: false})
   }


}

exports.updateProduct = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(422).json({
        message: errors.array().map(e => e.msg).join(', '),
        success: false
      });
    }


    const { productId } = req.params;


    const { name, description, price, photo_url, user_id } = req.body;

    // 🔒 Validaciones básicas
    const productIdNumber = parseInt(productId, 10);
    if (isNaN(productIdNumber)) {
      return res.status(400).json({
        message: 'Invalid product id',
        success: false
      });
    }

    if (!user_id) {
      return res.status(400).json({
        message: 'user_id is required',
        success: false
      });
    }

    const userIdNumber = parseInt(user_id, 10);
    if (isNaN(userIdNumber)) {
      return res.status(400).json({
        message: 'Invalid user id',
        success: false
      });
    }


    const product = await models.Product.findByPk(productIdNumber);

    if (!product) {
      return res.status(404).json({
        message: 'Product not found',
        success: false
      });
    }

    // 🔐 Verificar que el producto pertenece al usuario
    if (product.user_id !== userIdNumber) {
      return res.status(403).json({
        message: 'You are not allowed to update this product',
        success: false
      });
    }

    // 🧠 Construir updates dinámicos
    const updates = {};

    if (name !== undefined) {
      updates.name = name.trim();
    }

    if (description !== undefined) {
      updates.description = description.trim();
    }

    if (price !== undefined) {
      const priceNumber = parseFloat(price);
      if (isNaN(priceNumber) || priceNumber < 0) {
        return res.status(400).json({
          message: 'Invalid price',
          success: false
        });
      }
      updates.price = priceNumber;
    }

    if (photo_url !== undefined) {
      updates.photo_url = photo_url.trim();
    }

    // 🚀 Actualizar
    await product.update(updates);

    return res.status(200).json({
      message: 'Product updated successfully',
      success: true,
      data: product
    });

  } catch (err) {
    console.error('Update product error:', err);

    return res.status(500).json({
      message: 'Internal server error',
      success: false
    });
  }
};


