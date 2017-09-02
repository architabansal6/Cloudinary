//
//  Utility.swift
//  Cloudnary
//
//  Created by Archita Bansal on 9/2/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class Utility: NSObject {

    
    class func showAlert(title:String, message:String,handler:((_ alert:UIAlertAction) -> Void)? = nil){
        (UIApplication.shared.delegate as! AppDelegate).window?.endEditing(true)
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
}
