const express = require('express')
const models = require('../models')
const { Op} = require('sequelize')
const bcrypt = require('bcrypt')
const {validationResult} = require('express-validator');


exports.register = async (req, res) => {
    const errors = validationResult(req)

    if(!errors.isEmpty()){
        const msg = errors.array().map(err => err.msg).join('')
        return res.status(422).json({success: false, message: msg})
    }

    try{
    const { username, password } = req.body
    
    const existinUser = await models.User.findOne({
        where:{
            username: {[Op.iLike]: username}
        }
    })

    if(existinUser){
        return res.json({message: 'username already taken', success: false})
    }
    
    //create a password hash
    const salt = await bcrypt.genSalt(10)
    const hash =  await bcrypt.hash(password, salt)
   
    //create a neew user
    const _ =  models.User.create({
        username: username,
        password: hash
    })

    res.status(201).json({success: true})

}catch(err){
    res.status(500).json({ message: 'internal server error',success: false})
}

}