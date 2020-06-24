//
//  ActivityIndicator.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/23/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

final class ActivityIndicatorView : UIActivityIndicatorView {
    
    // MARK: Initializers
    
    init() {
        super.init(style: UIActivityIndicatorView.Style.large)
        clipsToBounds = true
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        color = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Superclass methods
    
    override func stopAnimating() {
        super.stopAnimating()
        removeFromSuperview()
    }
    
    // MARK: Public methods
    
    func addIn(view: UIView){
        view.addSubview(self)
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        widthAnchor.constraint(equalToConstant: 120).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.bringSubviewToFront(self)
    }
    
}
