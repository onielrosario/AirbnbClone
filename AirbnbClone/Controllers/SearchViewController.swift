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

class SearchViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var priceRangeMinlabel: UILabel!
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var priceRangeValueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
                let placeMark = placeMark.first
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placeMark?.location?.coordinate)!
                let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
                let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                annotation.title = searchText
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                self.locationNameLabel.text = searchText
                self.searchBar.text = ""
            }
        }
    }
}

extension SearchViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.pinTintColor = UIColor.init(r: 241, g: 159, b: 132)
        return annotationView
    }
}


