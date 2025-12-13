//
//  Uploader.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 13/12/25.
//

import Foundation


enum MimeType: String{
    case jpg = "image/jpg"
    case png = "image/png"
    
    var value: String{
        return self.rawValue
    }
}
struct Uploader {

    // HTTP client used to make network requests
    let httpClient: HTTPClient
    
    // Uploads raw data (image by default) and returns the uploaded file URL
    func upload(data: Data, mimeType: MimeType = .png) async throws -> UploadDataResponse {
        
        // Generates a unique boundary for multipart/form-data
        let boundary = UUID().uuidString
        
        // Sets the Content-Type header with multipart boundary
        let headers = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        // Creates the multipart/form-data body with the image data
        let body = createMultipartFormDataBody(
            data: data,
            boundary: boundary
        )
        
        // Creates the API resource for uploading the image
        let resource = Resource(
            url: Constants.Urls.uploadProductImage,
            method: .post(body),
            headers: headers,
            modelType: UploadDataResponse.self
        )
        
        // Executes the request and waits for the response
        let response = try await httpClient.load(resource)
        
        // Returns the downloaded image URL from the response
        return response
    }
    
    // Builds the multipart/form-data body manually
    private func createMultipartFormDataBody(
        data: Data,
        mimeType: MimeType = .png,
        boundary: String
    ) -> Data {
        
        var body = Data()
        
        // Line break required by multipart format
        let lineBreak = "\r\n"
        
        // Opening boundary
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        
        // Content disposition: tells server this is a file named "upload.png"
        body.append(
            "Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\(lineBreak)"
                .data(using: .utf8)!
        )
        
        // Content type of the file (image/png by default)
        body.append(
            "Content-Type: \(mimeType.value)\(lineBreak)\(lineBreak)"
                .data(using: .utf8)!
        )
        
        // Actual binary file data
        body.append(data)
        
        // Line break after file data
        body.append(lineBreak.data(using: .utf8)!)
        
        // Closing boundary
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        // Returns the complete multipart body
        return body
    }
}

