//
//  NewPostController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore



class NewPostController: UIViewController {
    @IBOutlet weak var postImage: UIImageView?
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postStepper: UIStepper!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var PriceTF: UITextField!
    private var tap: UITapGestureRecognizer!
    @IBOutlet weak var datesButton: UIButton!
    private var storagemanager: StorageManager!
    private var usersession: UserSession!
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.allowsEditing = true
        ip.delegate = self
        return ip
    }()
    private var numberOfRooms = 0
    private var descriptionString = ""
    private var address = ""
    private var lat: Double!
    private var Long: Double!
    private var startDate = ""
    private var endDate = ""
    private var newPostTitle = ""
    private var price: Double!
    private var locationController: LocationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationMainController = storyboard.instantiateViewController(withIdentifier: "LocationMapVC") as! LocationViewController
        return locationMainController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        storagemanager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        setupFields()
        locationController.delegate = self
        updatePostImage()
    }
    
    private func updatePostImage() {
        postImage!.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(photoPressed))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        postImage!.addGestureRecognizer(tap)
    }
    
    @objc private func photoPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.showImagePickerController()
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.showImagePickerController()
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupFields() {
        postTitle.delegate = self
        PriceTF.delegate = self
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        numberOfRooms = Int(sender.value)
        roomsLabel.text = "Rooms: \(Int(sender.value))"
        
    }
    
    @IBAction func availability(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let calendar = storyboard.instantiateViewController(withIdentifier: "calendarVC") as! CalendarViewController
        navigationController?.pushViewController(calendar, animated: true)
        calendar.delegate = self
    }
    
    
    
    @IBAction func addInfoPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postVC = storyboard.instantiateViewController(withIdentifier: "DescriptionVC") as? DescriptionController else { return }
        navigationController?.modalPresentationStyle = .overCurrentContext
        postVC.delegate = self
        present(postVC, animated: true, completion: nil)
    }
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        navigationController?.pushViewController(locationController, animated: true)
        locationController.delegate = self
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        guard let user = usersession.getCurrentUser() else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activity = storyboard.instantiateViewController(withIdentifier: "ActivityVC") as! ActivityViewController
        guard let imageData = postImage!.image?.jpegData(compressionQuality: 1.0) else  {
            showAlert(title: "No Image", message: "add a Listing image.", actionTitle: "OK")
            return
        }
        activity.modalPresentationStyle = .overCurrentContext
        present(activity, animated: true, completion: nil)
        storagemanager.uploadNewPostImage(withData: imageData) { (url, error) in
            if let error = error {
                print(error)
            } else if let url = url {
                guard !self.newPostTitle.isEmpty, !self.address.isEmpty else {
                    activity.dismiss(animated: true, completion: nil)
                    self.showAlert(title: "", message: "all textfields must be filled", actionTitle: "ok")
                    return
                }
                guard !self.startDate.isEmpty, !self.endDate.isEmpty else {
                     activity.dismiss(animated: true, completion: nil)
                    self.showAlert(title: "", message: "Must add a valid Date", actionTitle: "OK")
                    return
                }
                guard !self.descriptionString.isEmpty else {
                     activity.dismiss(animated: true, completion: nil)
                    self.showAlert(title: "", message: "Add description to post.", actionTitle: "OK")
                    return
                }
                
                let newPostCollection = UserCollection.init(title: self.newPostTitle, rooms: self.numberOfRooms, price: self.price, address: self.address, lat: self.lat, long: self.Long, description: self.descriptionString, startDate: self.startDate, endDate: self.endDate, userID: user.uid, postImage: url.absoluteString, dbReferenceDocumentId: "")
                DatabaseManager.addUserPostToDatabase(collectionInfo: newPostCollection)
                activity.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
               self.showAlert(title: "success", message: "new post added", actionTitle: "OK")
            }
        }
    }
}

extension NewPostController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         textField.resignFirstResponder()
        guard let title = postTitle.text,
            let price = PriceTF.text else {
                return
        }
        self.newPostTitle = title
        self.price = Double(price)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewPostController: DescriptionDelegate {
    func updateDescription(desctiption: String) {
        self.descriptionString = desctiption
    }
}

extension NewPostController: NewPostAdressLocationDelegate {
    func newPostAddress(addressTittle: String, coordinate: CLLocationCoordinate2D) {
        self.address = addressTittle
        self.lat = coordinate.latitude
        self.Long = coordinate.longitude
    }
}

extension NewPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error with image", message: "try again", actionTitle: "OK")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let activity = storyboard.instantiateViewController(withIdentifier: "ActivityVC") as! ActivityViewController
        postImage!.image = originalPhoto
        activity.dismiss(animated: true, completion: nil)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension NewPostController: CalendarDateSelectedDelegate {
    func didSelectDates(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
}
