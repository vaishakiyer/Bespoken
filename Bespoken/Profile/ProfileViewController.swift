//
//  ProfileViewController.swift
//  Bespoken
//
//  Created by Mohan on 13/12/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import YLProgressBar
import Alamofire
import Photos

class ProfileViewController: UIViewController {

    @IBOutlet var editProfileImageButton: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var tableHeaderTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var profileImage: UIImageView!
    @IBAction func editProfileAction(_ sender: Any) {
        let alertController =  UIAlertController(title: "Upload Profile Image", message: "", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Open Photos", style: .default, handler: {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.checkPermission(imagePicker: imagePicker )

            }
        })
        let cameraAction = UIAlertAction(title: "Open Camera", style: .default, handler: {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        BSUserDefaults.removeAll()
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerNav") as! UINavigationController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = loginVC
    }
    var styleWords : [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup()  {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.profileImage.image = BSUserDefaults.getProfilePic()
        self.profileImage.roundCorners(corners: .allCorners, radius: profileImage.frame.width / 2)
        self.editProfileImageButton.tintColor = UIColor.white
        self.logoutButton.roundCorners(corners: UIRectCorner(arrayLiteral: .allCorners), radius: 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.progressBar.setProgress(0.8, animated: true)
        self.progressBar.layer.cornerRadius = 10
        self.progressBar.clipsToBounds = true
        self.createNav()
        
 
        self.styleWords = BSUserDefaults.getLoggedWords()
        if styleWords == nil {
            self.getStylewords()

        }
        self.tableView.tableHeaderView = UIView()

        var x  = ""

    }
    
    func createNav() {
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
        let motifView = UIImageView(image: UIImage(named: "Motif_white"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackMotif_white"), style: .done, target: self, action: #selector(backPressed))

        motifView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = motifView
    }
    @objc func backPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    func checkPermission(imagePicker : UIImagePickerController) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.present(imagePicker, animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.present(imagePicker, animated: true, completion: nil)
                    print("success")
                    
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}
extension ProfileViewController : UITableViewDelegate{
    
}
extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.styleWords?.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileTimelineTableViewCell") as! ProfileTimelineTableViewCell
        cell.label.text = self.styleWords![indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
    
    
}
extension ProfileViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        BSUserDefaults.setProfilePic(image)
        self.profileImage.image = BSUserDefaults.getProfilePic().af_imageRoundedIntoCircle()
        dismiss(animated:true, completion: nil)
    }

}
extension ProfileViewController : UINavigationControllerDelegate{
    
}
extension ProfileViewController {
    
    func getStylewords(){
        
        Alamofire.request(Router.getStyleWords()).responseJSON { (response) in
            
            switch response.result{
                
            case .success(let JSON):
                
                print(JSON)
                
                guard let wordList = (JSON as? NSDictionary)?.value(forKey: "words") as? [String] else {return}
                
                BSUserDefaults.setLoggedWords(wordList)
                
                self.tableView.reloadData()
                //   self.creativeLabel.text = labelValue
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
}

