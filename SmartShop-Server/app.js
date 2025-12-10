const express = require('express')

const authRoutes = require('./Routes/auth')

const app = express()

app.use(express.json())

//register route
app.use('/api/auth', authRoutes)

app.listen(8080, () => {
    console.log('Server is running on port 8080')
})