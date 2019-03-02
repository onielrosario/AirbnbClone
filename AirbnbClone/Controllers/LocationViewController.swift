//
//  LocationViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit


protocol NewPostAdressLocationDelegate: AnyObject {
    func newPostAddress(addressTittle: String, coordinate: CLLocationCoordinate2D)
}


class LocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: NewPostAdressLocationDelegate?
    private var address = ""
    private var locationResultsController: LocationResultsViewController = {
        let storyboard = UIStoryboard(name: "LocationResults", bundle: nil)
        let locationMainController = storyboard.instantiateViewController(withIdentifier: "LocationResultsVC") as! LocationResultsViewController
        return locationMainController
        
    }()
    
    private lazy var searchBarController: UISearchController = {
        let sc = UISearchController(searchResultsController: locationResultsController)
        sc.searchResultsUpdater = locationResultsController
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.placeholder = "search for address"
        sc.dimsBackgroundDuringPresentation = false
        sc.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        sc.searchBar.autocapitalizationType = .none
        return sc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationResultsController.delegate = self
        locationResultsController.updateDelegate = self
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchBarController
        title = "Address"
    }
}



extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation?.coordinate {
            if let locationTitle = view.annotation?.title {
                showAlert(title: "Location Selected", message: locationTitle, style: .alert) { (alert) in
                    self.delegate?.newPostAddress(addressTittle: locationTitle!, coordinate: location)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
}

extension LocationViewController: LocationResultsControllerDelegate {
    func didSelectCoordinate(_ locationResultsController: LocationResultsViewController, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1400, longitudinalMeters: 1400)
        self.mapView.setRegion(region, animated: true)
        annotation.title = self.address
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
    }
    
    func didScrollTableView(_ locationResultsController: LocationResultsViewController) {
        searchBarController.searchBar.resignFirstResponder()
    }
}

extension LocationViewController: UpdateAddressPostControllerDelegate {
    func UpdatePostAdress(addressTittle: String, addressSubtittle: String) {
        self.address = """
        \(addressTittle),
        \(addressSubtittle)
        """
    }
    
    
}
