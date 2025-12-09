const express = require('express')
const app = express()
app.use(express.json())
const models = require('./models')

app.post('/register', (req, res) => {
    const { username, password } = req.body

    //create a neew user
    const newUser =models.User.create({
        username: username,
        password: password
    })

    res.status(201).json({success: true})

})


app.listen(8080, () => {
    console.log('Server is running on port 8080')
})