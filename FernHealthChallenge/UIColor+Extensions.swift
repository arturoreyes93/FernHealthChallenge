//
//  UIColor+Extensions.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/23/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: Int32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
    
    class var darkGreen: UIColor { return UIColor(hex: 0x003033) }
    
    class var bubbleGreen: UIColor { return UIColor(hex: 0xC4C4C4) }
    
    class var mayonnaise: UIColor { return UIColor(hex: 0xFBF7F1) }
    
    class var rose: UIColor { return UIColor(hex: 0xFBC5BD) }
}
