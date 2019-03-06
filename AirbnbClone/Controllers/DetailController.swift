//
//  DetailController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 3/5/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit

class DetailController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var regionMapview: MKMapView!
    @IBOutlet weak var davailableDatesLabel: UILabel!
    var listingInfo: UserCollection!
    override func viewDidLoad() {
        super.viewDidLoad()
        regionMapview.delegate = self
    configureDetail()
    }
    
    private func configureDetail() {
        ImageCache.shared.fetchImageFromNetwork(urlString: listingInfo.postImage) { (error, image) in
            if let error = error {
                print(error)
            } else if let image = image {
                self.detailImage.image = image
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
    }
    
    

}

extension DetailController: MKMapViewDelegate {
    
}
