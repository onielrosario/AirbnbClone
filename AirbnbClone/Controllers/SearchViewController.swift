//
//  ViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/15/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var priceRangeMinlabel: UILabel!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var priceRangeMaxLabel: UILabel!
    @IBOutlet weak var maxRange: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text,
            !searchText.isEmpty else {
                showAlert(title: "", message: "Please enter a place name.")
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
