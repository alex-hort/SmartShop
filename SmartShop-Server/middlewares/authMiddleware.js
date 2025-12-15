const jwt = require('jsonwebtoken');
const models = require('../models');

const authenticate = async (req, res, next) => {

    const authHeader = req.headers['authorization'];
    if (!authHeader) {
        return res.status(401).json({ message: 'No token provided', success: false });
    }

    const token = authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: 'Invalid token', success: false });
    }

    try {
        const decoded = jwt.verify(token, 'SECRETKEY');

        const user = await models.User.findByPk(decoded.userId);
        if (!user) {
            return res.status(401).json({ message: 'User not found', success: false });
        }

        req.user = user;
        next();
    } catch (error) {
        return res.status(401).json({ message: 'Unauthorized access', success: false });
    }
};

module.exports = authenticate;
