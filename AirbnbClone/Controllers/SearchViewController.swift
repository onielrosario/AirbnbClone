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
        searchBar.becomeFirstResponder()
        guard let searchText = searchBar.text,
        !searchText.isEmpty else { return }
        
        
    }
}
