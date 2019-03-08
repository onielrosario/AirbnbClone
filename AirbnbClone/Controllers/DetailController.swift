//
//  DetailController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 3/5/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class DetailController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var regionMapview: MKMapView!
    @IBOutlet weak var davailableDatesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var usersession: UserSession!
    var listingInfo: UserCollection!
    override func viewDidLoad() {
        super.viewDidLoad()
        regionMapview.delegate = self
        configureDetail()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
//       configureFaveButton()
    }
    
    private func configureFaveButton() {
        if let _ = navigationController?.parent?.children[1].children[0] as? SavedViewController {
            self.favoriteButton.isEnabled = false
            self.favoriteButton.setImage(UIImage(named: "Liked"), for: .normal)
        }
    }
    
    private func configureDetail() {
        ImageCache.shared.fetchImageFromNetwork(urlString: listingInfo.postImage) { (error, image) in
            if let error = error {
                 self.detailImage.image = UIImage(named: "locationPlaceholder")
                print(error)
            } else if let image = image {
                self.detailImage.image = image
            } else {
                self.detailImage.image = UIImage(named: "locationPlaceholder")
            }
        }
        titlelabel.text = listingInfo.title
        locationLabel.text = listingInfo.address
        descriptionLabel.text = """
        \(listingInfo.description)
        number of rooms: \(listingInfo.rooms)
        price: $\(Int(listingInfo.price)).00 per night!
        """
        davailableDatesLabel.text = "from: \(listingInfo.startDate) / to: \(listingInfo.endDate)"
        let coordinate = CLLocationCoordinate2D(latitude: listingInfo.lat, longitude: listingInfo.long)
        let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        regionMapview.setRegion(region, animated: true)
        regionMapview.isScrollEnabled = false
        regionMapview.isZoomEnabled = false
    }
    
    
    
    @IBAction func bookButton(_ sender: UIButton) {
        
    }
    
    @IBAction func favortireButton(_ sender: UIButton) {
        // get doc id
        let dbRef = DatabaseManager.firebaseDB
            .collection(DatabaseKeys.FavoritesCollectionKey)
            .document()
        
        let newFavoriteCollection = UserCollection.init(title: listingInfo.title, rooms: listingInfo.rooms, price: listingInfo.price, address: listingInfo.address, lat: listingInfo.lat, long: listingInfo.long, description: listingInfo.description, startDate: listingInfo.startDate, endDate: listingInfo.endDate, userID:listingInfo.userID, postImage: listingInfo.postImage, dbReferenceDocumentId: dbRef.documentID)
        DatabaseManager.saveUserPostToFavoritesDatabase(userCollection: newFavoriteCollection, documentId: dbRef.documentID)
        self.showAlert(title: "success", message: "added to favorites", actionTitle: "OK")
        self.favoriteButton.isEnabled = false
        self.favoriteButton.setImage(UIImage(named: "Liked"), for: .normal)
    }
}

extension DetailController: MKMapViewDelegate {
    
}
