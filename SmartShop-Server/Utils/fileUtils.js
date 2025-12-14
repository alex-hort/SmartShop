const fs = require('fs');
const path = require('path');

//extract filename from a given  ulr 

const getFilenameFromUrl = (photoUrl) => {
    
    try {
        const url = new URL(photoUrl);
        const filename = path.basename(url.pathname);
        return filename;

    }catch (error) {
        console.error('Error extracting filename from URL:', error);
        return null;
    }
}


const deleteFile = (filename) => {
    
    return new Promise((resolve, reject) => {
        if(!filename){
            return resolve()
        }
        const fullImagePath = path.join(__dirname,'../uploads', filename);

        fs.access(fullImagePath, fs.constants.F_OK, (err) => {

            if(err){
                console.warn('File does not exist:', fullImagePath);
                return resolve();
            }
        
    })

    fs.unlink(fullImagePath, (err) => {
        if(err){
            console.error('Error deleting file:', err);
            return reject(err);
        } else {
            console.log('File deleted successfully:', fullImagePath);
            return resolve();
        }
    })
})  
    
}

module.exports = {
    getFilenameFromUrl,
    deleteFile
}