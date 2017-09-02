
//
//  CloudnaryHelper.swift
//  Cloudnary
//
//  Created by Archita Bansal on 9/2/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit
import Cloudinary

class CloudnaryHelper: NSObject {

    static let cloudinaryHelperSharedInstance = CloudnaryHelper()
    var cloudinary:CLDCloudinary?
    var params:CLDUploadRequestParams?
  
   
    // MARK: - Initial setup methods
    func setUpCloudinary(width:Int,height:Int){
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://298196278743443:n7YIbNo_yjfZ9aYFQyrBPHICKxo@djh61nscs")
        cloudinary = CLDCloudinary(configuration: config!)
        params = CLDUploadRequestParams()
        let transformation = CLDTransformation().setWidth(width).setHeight(height)
        params?.setTransformation(transformation)
    }
    
    // MARK: - Image Uploader method
    
    func downloadImage(imageURL:String,onCompletion: @escaping (_ status: Bool, _ image:UIImage?) -> Void){
        
        cloudinary?.createDownloader().fetchImage(imageURL, { (progress) in
            //Handle progress
            
        }, completionHandler: { (image, error) in
            // Handle response
            if error != nil{
                onCompletion(false,nil)
            }else{
                onCompletion(true,image)
            }

        })
    }
    
    func uploadImage(image: UIImage) {
       // self.params?.setPublicId(id)
        let data = UIImagePNGRepresentation(image) as Data?
        cloudinary?.createUploader().signedUpload(data: data!, params: params, progress: { (progress)  in
            // Handle upload progress
            
        }, completionHandler: { (response, error) in
            // Handle response
            if error != nil{
                print("upload failed")
            }else{
                self.updateImageURLArray(url: (response?.url!)!)
            }
        })
    }
    
    func updateImageURLArray(url:String){
        let defaults = UserDefaults.standard
        
        var imageURLArray = defaults.object(forKey: "imageURLs") as? [String] ?? [String]()
        
        imageURLArray.append(url)
        
        // then update whats in the `NSUserDefault`
        defaults.set(imageURLArray, forKey: "imageURLs")
        
        // call this after you update
        defaults.synchronize()
    }
    
    func downloadImages(onCompletion: @escaping (_ status: Bool, _ image:UIImage?) -> Void){
        
        let imageURLArray = UserDefaults.standard.object(forKey: "imageURLs") as? [String] ?? [String]()
        for url in imageURLArray{
            self.downloadImage(imageURL: url, onCompletion: { (status, image) in
                if status{
                    if let img = image{
                        onCompletion(true,img)
                    }
                }else{
                    Utility.showAlert(title: "", message: "No Image to download")
                }
            })
        }
        
    }
    
}
