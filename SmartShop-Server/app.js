const express = require('express')

const authRoutes = require('./Routes/auth')
const productsRoutes = require('./Routes/product')

const app = express()
app.use('/api/uploads', express.static('uploads'))


app.use(express.json())

//register route
app.use('/api/auth', authRoutes)
app.use('/api/products', productsRoutes)


app.listen(8080, () => {
    console.log('Server is running on port 8080')
})