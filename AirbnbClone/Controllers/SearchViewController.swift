//
//  ViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/15/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit
import SwiftRangeSlider
import FirebaseFirestore

class SearchViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var priceRangeMinlabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var priceRangeValueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    var pointAnnotation: CustomPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    private var listener: ListenerRegistration!
    private var places = [UserCollection]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.reloadInputViews()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        searchBar.delegate = self
        mapView.delegate = self
        priceRangeValueLabel.text = "$20 - $1,000+"
        self.locationNameLabel.text = "Search for location"
        setSearchBarColor()
        getPosts()
    }
    
    private func getPosts() {
        places.removeAll()
        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.DocumentsCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapShot, error) in
            if let error = error {
                self.showAlert(title: "network error", message: error.localizedDescription, actionTitle: "OK")
            } else if let snapshot = snapShot {
                var places = [UserCollection]()
                for document in snapshot.documents {
                    let allPlaces = UserCollection(dict: document.data())
                    places.append(allPlaces)
                }
            print("\(places.count)")
                self.places = places
            }
        }
    }
    
    
    @IBAction func rangeSliderChanged(_ sender: RangeSlider) {
        let maxValue = Int(sender.upperValue)
        let minValue = Int(sender.lowerValue)
        self.priceRangeValueLabel.text = "$\(minValue) - $\(maxValue)"
    }
    
    private func setSearchBarColor() {
        searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = ""
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text,
            !searchText.isEmpty else {
                showAlert(title: "missing fields", message: "name of place or location requited", actionTitle: "OK")
                return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { (placeMark, error) in
            if let error = error {
                print(error)
            } else if let placeMark = placeMark {
                for place in self.places {
                    let placeMark = placeMark.first
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
                    let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
                    let region = MKCoordinateRegion(center: (placeMark?.location?.coordinate)!, span: span)
                    self.mapView.setRegion(region, animated: true)
                    annotation.title = place.title
                    self.mapView.addAnnotation(annotation)
                    self.locationNameLabel.text = searchText
                    self.searchBar.text = ""
                }
            }
        }
    }
}

extension SearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.markerTintColor = UIColor.init(r: 241, g: 159, b: 132)
        annotationView.glyphImage =  UIImage(named: "houseIcon")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailController
        guard let annotation = view.annotation else {
            return
        }
        let index = places.index { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == $0.coordinate.longitude
        }
        if let placeindex = index {
            let listingInfo = places[placeindex]
            detailVC.listingInfo = listingInfo
            navigationController?.modalPresentationStyle = .popover
            navigationController?.modalTransitionStyle = .flipHorizontal
           navigationController?.pushViewController(detailVC, animated: true)
        }
     mapView.deselectAnnotation(annotation, animated: true)
    }
    
    
    
}


