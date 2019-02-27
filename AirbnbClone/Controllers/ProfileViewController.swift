
//
//  ProfileViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/16/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    private var usersession: UserSession!
     private var storagemanager: StorageManager!
    @IBOutlet weak var profileTableView: UITableView!
  
    @IBOutlet weak var newPost: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        storagemanager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        usersession.usersessionSignOutDelegate = self
        storagemanager.delegate = self
        
    }
    
    @IBAction func newPostButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postVC = storyboard.instantiateViewController(withIdentifier: "NewPostVC") as? NewPostController else { return }
       navigationController?.pushViewController(postVC, animated: true)
        print("new post pressed")
        
    }
    
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        usersession.signOut()
    }
    
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        let user = usersession.getCurrentUser()
        if user != nil {
            cell.profileName.text = user?.email
        } else {
            cell.profileName.text = "no user logged in"
        }
        
        return cell
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}

extension ProfileViewController: UserSessionSignOutDelegate {
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        
    }
}

extension ProfileViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
        
    }
    
    
}
