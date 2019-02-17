//
//  UIViewController+Alerts.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController {
  
  public func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func showAlert(title: String, message: String, handler: @escaping (UIAlertController) -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    handler(alertController)
  }
}
