//
//  LocationViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
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
        navigationController?.navigationBar.prefersLargeTitles = true
//       navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchBarController
        title = "Address"
    }
    
}

extension LocationViewController: MKMapViewDelegate {
    
}

extension LocationViewController: LocationResultsControllerDelegate {
    func didSelectCoordinate(_ locationResultsController: LocationResultsViewController, coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1400, longitudinalMeters: 1400)
        mapView.setRegion(region, animated: true)
    }
    
    func didScrollTableView(_ locationResultsController: LocationResultsViewController) {
        searchBarController.searchBar.resignFirstResponder()
    }
    
    
}
