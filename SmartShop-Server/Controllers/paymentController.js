const stripe = require('stripe')

exports.createPaymentIntent = async (req, res) => {
  try {
    const { totalAmount } = req.body

    if (typeof totalAmount !== 'number' || isNaN(totalAmount)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid total amount'
      })
    }

    const totalAmountInCents = Math.round(totalAmount * 100)

    const customer = await stripe.customers.create()

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: '2022-11-15' }
    )

    const paymentIntent = await stripe.paymentIntents.create({
      amount: totalAmountInCents,
      currency: 'usd',
      customer: customer.id,
      automatic_payment_methods: { enabled: true },
    })

    res.json({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customer.id,
      publishableKey: process.env.STRIPE_PUBLISHABLE_KEY
    })

  } catch (error) {
    console.error(error)
    res.status(500).json({
      success: false,
      error: error.message
    })
  }
}
