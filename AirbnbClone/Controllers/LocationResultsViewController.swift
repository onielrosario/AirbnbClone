//
//  LocationResultsViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/28/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import MapKit

protocol LocationResultsControllerDelegate: AnyObject {
    func didSelectCoordinate(_ locationResultsController: LocationResultsViewController, coordinate: CLLocationCoordinate2D)
    func didScrollTableView(_ locationResultsController: LocationResultsViewController)
}

protocol UpdateAddressPostControllerDelegate: AnyObject {
    func UpdatePostAdress(addressTittle: String, addressSubtittle: String)
}

class LocationResultsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var searchCompleter = MKLocalSearchCompleter()
    private var completions = [MKLocalSearchCompletion]()
    weak var delegate: LocationResultsControllerDelegate?
    weak var updateDelegate: UpdateAddressPostControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchCompleter.delegate = self
    }
}

extension LocationResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultsCell", for: indexPath)
        let suggestion = completions[indexPath.row]
        cell.textLabel?.text = suggestion.title
        cell.detailTextLabel?.text = suggestion.subtitle
        return cell
    }
    
}

extension LocationResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = completions[indexPath.row]
        let addressString = (suggestion.title + " " + suggestion.subtitle).trimmingCharacters(in: .whitespacesAndNewlines) //suggestion.title.isEmpty ? suggestion.title : suggestion.subtitle
        LocationService.getCoordinate(addressString: addressString) { (coordinate, error) in
            if let error = error {
                print("error in coordinate:n \(error)")
            } else {
                self.updateDelegate?.UpdatePostAdress(addressTittle: suggestion.title, addressSubtittle: suggestion.subtitle)
                self.delegate?.didSelectCoordinate(self, coordinate: coordinate)
            }
        }
        dismiss(animated: true)
    }
}

extension LocationResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}


extension LocationResultsViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("local search completer encountered an error: \(error.localizedDescription)")
        }
    }
}

extension LocationResultsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollTableView(self)
    }
}
