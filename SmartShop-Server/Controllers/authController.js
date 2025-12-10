const express = require('express')
const jwt = require('jsonwebtoken')
const models = require('../models')
const { Op, where} = require('sequelize')
const bcrypt = require('bcrypt')
const {validationResult} = require('express-validator');



exports.login = async (req, res) => {

    try {
    //validate input 
      const errors = validationResult(req)
    if(!errors.isEmpty()){
        const msg = errors.array().map(err => err.msg).join('')
        return res.status(422).json({success: false, message: msg})
    }

    const { username, password } = req.body

    //check if user exists

    const existinUser = await models.User.findOne({
        where:{
            username: {[Op.iLike]: username}
        }
        })

        if (!existinUser){
            return res.status(401).json({message: 'invalid credentials', success: false});

        }
        ///check the password
       const isPasswordValid = await bcrypt.compare(password, existinUser.password)

       if(!isPasswordValid){
        return res.status(401).json({message: 'invalid credentials', success: false});
       }

       //if the password is valid
       //generate a token (skipped for now)
       const token = jwt.sign({userId: existinUser.id}, 'SECRETKEY', {
        expiresIn: '1h'
       })

       return res.status(200).json({userId: existinUser.id, username: existinUser.username, token: token, success: true})

    }catch(err){

        res.status(500).json({ message: 'internal server error',success: false})

    }


}


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