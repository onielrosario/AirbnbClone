//
//  DescriptionController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit


protocol DescriptionDelegate: AnyObject {
    func updateDescription(desctiption: String)
}



class DescriptionController: UIViewController {
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionInfo: UITextView!
    @IBOutlet weak var button: UIButton!
    weak var delegate: DescriptionDelegate?
    @IBOutlet var tap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionInfo.layer.cornerRadius = 10
        button.layer.cornerRadius = 10
        descriptionInfo.allowsEditingTextAttributes = true
        descriptionInfo.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        descriptionView.addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
      descriptionInfo.resignFirstResponder()
    }
    
    
    @IBAction func doneDescriptionPressed(_ sender: UIButton) {
        print("description button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DescriptionController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text  else {
            return
        }
        textView.resignFirstResponder()
        delegate?.updateDescription(desctiption: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        textView.text = ""
    }
    

   
    
}
