const express = require('express')
const models = require('./models')
const {body, validationResult} = require('express-validator');

const app = express()

app.use(express.json())



const registerValidator = [
    body('username', 'username cannot be empty').not().isEmpty(),
     body('password', 'password cannot be empty').not().isEmpty(),
]




app.post('/register',registerValidator, (req, res) => {

    const errors = validationResult(req)

    if(!errors.isEmpty()){
        const msg = errors.array().map(err => err.msg).join('')
        return res.status(422).json({success: false, message: msg})
    }

    const { username, password } = req.body
    
   
    //create a neew user
    const newUser =  models.User.create({
        username: username,
        password: password
    })

    res.status(201).json({success: true})

})


app.listen(8080, () => {
    console.log('Server is running on port 8080')
})