const models = require('../models');
const cartController = require('./carController');

exports.createOrder = async (req, res) => {


     const errors = validationResult(req)
        if(!errors.isEmpty()){
            const msg = errors.array().map((e) => e.msg).join(', ')
            return res.status(422).json({message: msg, succeess: false})
        }


  const userId = req.userId;
  const { total, order_items } = req.body;
  const transaction = await models.sequelize.transaction();
  
  try {
    // Crear la orden
    const newOrder = await models.Order.create({
      user_id: userId,
      total: total
    }, { transaction });

    // Crear los items de la orden
    const orderItemData = order_items.map(item => ({
      product_id: item.product_id,
      quantity: item.quantity,
      order_id: newOrder.id
    }));
    
    await models.OrderItem.bulkCreate(orderItemData, { transaction });

    // Buscar el carrito del usuario
    const cart = await models.Cart.findOne({
      where: { user_id: userId },
      attributes: ['id']
    });

    // Solo limpiar el carrito si existe
    if (cart) {
      // Limpiar los items del carrito
      await cartController.deleteCartItem(cart.id, transaction);
    }

    // Commit de la transacción
    await transaction.commit();

    return res.status(201).json({
      message: 'Order created successfully.',
      success: true,
      orderId: newOrder.id
    });

  } catch (error) {
    await transaction.rollback();
    console.error('Error creating order:', error);
    
    return res.status(500).json({
      message: 'An error occurred while creating the order.',
      success: false,
      error: error.message
    });
  }
};