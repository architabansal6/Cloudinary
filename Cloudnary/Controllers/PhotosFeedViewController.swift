//
//  PhotosFeedViewController.swift
//  Cloudnary
//
//  Created by Archita Bansal on 9/2/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PhotosFeedViewController: UIViewController {

    @IBOutlet weak var outletAddButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    
    var imagesData = [UIImage]()
    fileprivate let reuseIdentifier = "photoCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 16, left: 16 , bottom: 16, right: 16)
    var imageURLs = Array<String>()
    
    //MARK: VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CloudnaryHelper.cloudinaryHelperSharedInstance.setUpCloudinary(width: 200, height: 200)
        self.addRefreshButton()
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.downloadImages()
    }

    //MARK: ACTION METHODS
    
    @IBAction func onAddPhotos(_ sender: UIButton) {
        
        self.createActionSheet()
        
    }
    
    @IBAction func onFirstTransformButton(_ sender: UIButton) {
        CloudnaryHelper.cloudinaryHelperSharedInstance.setUpCloudinary(width: 200, height: 200)
    }
    
    @IBAction func onSecondTransformButton(_ sender: UIButton) {
        CloudnaryHelper.cloudinaryHelperSharedInstance.setUpCloudinary(width: 300, height: 300)
        
    }
    
    //MARK: Custom Methods
    
    func addRefreshButton(){
        
        let refreshBarButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshPhotos))
        
        refreshBarButton.setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!], for: UIControlState.normal)
        navigationItem.rightBarButtonItem = refreshBarButton
        
    }
    
    func refreshPhotos(){
        self.downloadImages()
    }
    
    func uploadImage(img:UIImage){
        CloudnaryHelper.cloudinaryHelperSharedInstance.uploadImage(image: img)
    }
    
    func downloadImages(){
        
        CloudnaryHelper.cloudinaryHelperSharedInstance.downloadImages{ (status, image) in
            DispatchQueue.main.async(execute: {
                if let img = image{
                    if !self.imagesData.contains(img){
                        self.imagesData.append(img)
                        self.photosCollectionView.reloadData()
                    }
                }else{
                    Utility.showAlert(title: "", message: "No Image found")
                }
            })
            
        }
    }
   

}
extension PhotosFeedViewController:UICollectionViewDataSource{
    // MARK: UICollectionViewDataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        
        cell.backgroundColor = UIColor.clear
        cell.imageView.image = self.imagesData[indexPath.row] 
        //cell.imageView.sd_setImage(with: NSURL.init(string: "https://farm\(self.photos[indexPath.row]["farm"]!).static.flickr.com/\(self.photos[indexPath.row]["server"]!)/\(self.photos[indexPath.row]["id"]!)_\(self.photos[indexPath.row]["secret"]!).jpg")! as URL)
        //        cell.paperImageView?.image = UIImage(named: "\(self.papers[indexPath.row])")
        
        return cell
    }
    
}
extension PhotosFeedViewController:UICollectionViewDelegate{
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //AppSettings.sharedInstance.paper = self.photos[indexPath.row]
        
    }
    
    
}
extension PhotosFeedViewController:UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = self.view.frame.width
        let width = (screenWidth - 64)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}

extension PhotosFeedViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func createActionSheet(){
       
        self.view.endEditing(true)
        
        let alertControl = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (UIAlertAction) in
            print("takePH")
            self.cameraTapped()
        }
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            print("choosePH")
            self.galleryTapped()
        }
        
        alertControl.addAction(cancelButton)
        alertControl.addAction(takePhoto)
        alertControl.addAction(choosePhoto)
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func galleryTapped()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType=UIImagePickerControllerSourceType.photoLibrary
        self.present(picker,animated:true,completion: nil)
    }
    
    func cameraTapped()
    {
        if(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let authStatus =  AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            
            switch authStatus{
            case AVAuthorizationStatus.authorized :
                //allowed access
                if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerControllerSourceType.camera) {
                    setUpAndPresentCameraView()
                }
            case AVAuthorizationStatus.notDetermined :
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
                    result in
                    if result{
                        self.setUpAndPresentCameraView()
                    }else{
                        self.showCameraEnableMessage()
                    }
                })
            case .denied:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
                    result in
                    if result{
                        self.setUpAndPresentCameraView()
                    }else{
                        self.showCameraEnableMessage()
                    }
                })
                
            default :
                self.showCameraEnableMessage()
                //ask to allow access
            }
        }
        else
        {
            //p("Camera Not Availble")
            showCameraEnableMessage()
        }
        
        
    }
    
    func showPhotosEnableMessage()
    {
        DispatchQueue.main.async
            {
                
        }
    }
    
    func showCameraEnableMessage(){
        DispatchQueue.main.async(execute: {
            self.outletAddButton.isEnabled = true
            //CommonFunc.showAlert("", message: "Enable Camera Access for Citrus App in Settings->Privacy->Camera")
        })
    }
    
    func setUpAndPresentCameraView(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing=true
        picker.sourceType=UIImagePickerControllerSourceType.camera
        
        self.present(picker,animated:true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        
        DispatchQueue.main.async(execute: {
            if let image = info[UIImagePickerControllerEditedImage] as! UIImage?{
               // selectedImage = image
                self.uploadImage(img: image)
            }else{
                Utility.showAlert(title: "Error", message: "Something went wrong. Could not fetch image. Please try again.", handler: nil)
            }
        })
//            let img = info[UIImagePickerControllerEditedImage] as? UIImage
//            self.uploadImage(img: img!)
//            self.outletAddButton.isEnabled = true
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.outletAddButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}

