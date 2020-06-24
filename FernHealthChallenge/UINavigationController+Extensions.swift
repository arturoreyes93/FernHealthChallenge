//
//  UINavigationController+Extensions.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setTransparentBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
}
