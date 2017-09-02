//
//  PhotosFeedViewController.swift
//  Cloudnary
//
//  Created by Archita Bansal on 9/2/17.
//  Copyright © 2017 archita. All rights reserved.
//


import UIKit

class AppSettings{
    
    static var sharedInstance = AppSettings()
    static let lightGreyForBackground = UIColor(red: 0.969, green: 0.973, blue: 0.976, alpha: 1) 
    
    var profileGalleryimagecache = NSCache<AnyObject, AnyObject>()

}
