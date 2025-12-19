
const model = require('../models');

exports.removeCartItem = async (req, res) => {

  try{
    const { cartItemId } = req.params;
    const deleteItem = await model.CartItem.destroy({
      where: {
        id: cartItemId
      }
    });

    if (!deleteItem) {
      return res.status(404).json({
        message: 'Cart item not found',
        success: false
      });
    }



  } catch (error) {
    res.status(500).json({
      message: 'An error occurred while removing the item from the cart',
      success: false
    });
  }


}





exports.loadCart = async (req, res) => {
  try {
    const cart = await model.Cart.findOne({
      where: {
        user_id: 5,
        is_active: true
      },
      attributes: ['id', 'user_id', 'is_active'],
      include: [
        {
          model: model.CartItem,
          as: 'cartItems',
          attributes: ['id', 'cart_id', 'product_id', 'quantity'],
          include: [
            {
              model: model.Product,
              as: 'product',
              attributes: ['id', 'name', 'description', 'price', 'photo_url', 'user_id']
            }
          ]
        }
      ]
    });

    res.status(200).json({
      message: 'Cart loaded successfully',
      success: true,
      cart: cart
    });

  } catch (error) {
     res.status(500).json({
      message: 'Internal server error',
      success: false
    });
  }
};





exports.addCartItem =  async (req, res)  => {
    // Logic to add item to cart

    const { productId, quantity } = req.body;


    req.userId = 5 

    try {
        //get the cart based on user id is active True
        let cart = await model.Cart.findOne({
            where: {
                user_id: req.userId,
                is_active: true
            }
        });

        if (!cart) {
            //create a new cart for the user
            cart = await model.Cart.create({
                 user_id: req.userId,
                is_active: true
            });
        }

        //add item to cart
        const [cartItem, created] = await model.CartItem.findOrCreate({
            where: {
                cart_id: cart.id,
                product_id: productId
            },
            defaults: { quantity}
        });
        
        
        if (!created) {
            //already exists, update quantity
            cartItem.quantity += quantity;
            //save the updated cart item
            await cartItem.save();
        }

        //get cartItem with product 
        const cartItemWithProduct = await model.CartItem.findOne({
            where: { id: cartItem.id },
            attributes: ['id', 'cart_id', 'product_id', 'quantity'],
            include: [{
                model: model.Product,
                as: 'product',
                attributes: ['id', 'name','description','price','photo_url', 'user_id']
            }]
        });

        res.status(200).json({
            message: 'Item added to cart successfully',
            success: true,
            cartItem: cartItemWithProduct
        })

    }catch (error) {
        console.log(error)

        return res.status(500).json({ message: 'Internal server error', success: false });
    }
};

