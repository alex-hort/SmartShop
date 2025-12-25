const express = require('express')

const authRoutes = require('./Routes/auth')
const productsRoutes = require('./Routes/product')
const cartRoutes = require('./Routes/cart')
const userRoutes = require('./Routes/user')
const authenticate = require('./middlewares/authMiddleware')


const app = express()
app.use('/api/uploads', express.static('uploads'))


app.use(express.json())

//register route
app.use('/api/auth', authRoutes)
app.use('/api/products', productsRoutes)

//cart route
app.use('/api/cart', authenticate,cartRoutes)

//user route
app.use('/api/user',authenticate, userRoutes)


app.listen(8080, () => {
    console.log('Server is running on port 8080')
})