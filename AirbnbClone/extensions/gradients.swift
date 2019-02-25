//
//  gradients.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/24/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
