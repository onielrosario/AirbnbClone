//
//  SavedViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/16/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SavedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var listener: ListenerRegistration!
    private var usersession: UserSession!
    var favorites = [UserCollection]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var userCreatedPost = [UserCollection]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
         usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        getFavorites()
    }
    
    private func getFavorites() {
        favorites.removeAll()
        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.FavoritesCollectionKey).addSnapshotListener(includeMetadataChanges: true, listener: { (snapShot, error) in
            if let error = error {
               self.showAlert(title: "Network error", message: error.localizedDescription, actionTitle: "OK")
            } else if let snapShot = snapShot {
                var userFavorites = [UserCollection]()
                var userCreatedCollection = [UserCollection]()
                for document in snapShot.documents {
                   let allFaves = UserCollection.init(dict: document.data())
                    guard let user = self.usersession.getCurrentUser() else  {
                        return
                    }
                    if allFaves.userID == user.uid {
                        userCreatedCollection.append(allFaves)
                    } else {
                        userFavorites.append(allFaves)
                    }
                    
                }
                self.favorites = userFavorites
                self.userCreatedPost = userCreatedCollection
            }
        })
        
    }
}

extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
           return 1
        case 1:
           return userCreatedPost.count
        default:
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "collectionTableCell", for: indexPath) as! SavedCollectionTableViewCell
            cell.collectionView.dataSource = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedListingCell", for: indexPath)
            let collection = userCreatedPost[indexPath.row]
            cell.textLabel?.text = collection.title
            cell.detailTextLabel?.text = collection.address
            ImageCache.shared.fetchImageFromNetwork(urlString: collection.postImage) { (error, image) in
                if let error = error {
                     cell.imageView?.image = UIImage(named: "locationPlaceholder")
                    print(error)
                } else if let image = image {
                    cell.imageView?.image = image
                } 
            }
           return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

extension SavedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedCollectionViewCell", for: indexPath) as! SavedCollectionViewCell
        let indexpath = favorites[indexPath.row]
        ImageCache.shared.fetchImageFromNetwork(urlString: indexpath.postImage) { (error, image) in
            if let error = error {
                print(error)
            } else if let image = image {
                cell.collectionViewCellImage.image = image
            } else {
                  cell.collectionViewCellImage.image = UIImage(named: "locationPlaceholder")
            }
        }
        cell.titleLabel.text = indexpath.title
        cell.subTitleLabel.text = indexpath.address
        return cell
    }
    
    
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    
}
