//
//  NewPostController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit




class NewPostController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postStepper: UIStepper!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var PriceTF: UITextField!
    private var descriptionString = ""
    private var address = ""
    private var lat: Double!
    private var Long: Double!
    private var locationController: LocationViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationMainController = storyboard.instantiateViewController(withIdentifier: "LocationMapVC") as! LocationViewController
        return locationMainController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
      locationController.delegate = self
    }
    
    private func setupFields() {
        postTitle.delegate = self
        PriceTF.delegate = self
        
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        roomsLabel.text = "Rooms: \(Int(sender.value))"
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
        navigationController?.popViewController(animated: true)
    }
}

extension NewPostController: UITextFieldDelegate {
    
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
     print(address + "\(lat ?? 0.0) , \(Long ?? 0.0)")
    }
    
    
}
