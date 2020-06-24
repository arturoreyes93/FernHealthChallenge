//
//  FeedbackViewController.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/20/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

final class FeedbackViewController: UIViewController {
    
    // MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGreen
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.text = LocalizedString("feedback_title")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGreen
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = LocalizedString("feedback_message")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightBubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "right_bubble_sand"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let leftBubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "left_bubble_sand"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let greenBubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "green_bubble"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let checkmark: UIImageView = {
        let image = UIImageView(image: UIImage(named: "checkmark"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let leftArrowView: UIImageView = UIImageView(image: UIImage(named: "left_arrow"))
    
    // MARK: Superclass methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mayonnaise
        setupLayout()
        leftArrowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pop)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: leftArrowView), animated: false)
    }
    
    // MARK: Private methods
    private func setupLayout() {
        
        
        view.insertSubview(rightBubble, at: 0)
        view.insertSubview(leftBubble, at: 1)
        view.insertSubview(greenBubble, at: 2)
        view.insertSubview(checkmark, at: 3)
        view.insertSubview(titleLabel, at: 4)
        view.insertSubview(promptLabel, at: 5)
        
        rightBubble.heightAnchor.constraint(equalToConstant: 270).isActive = true
        rightBubble.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightBubble.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150).isActive = true
        rightBubble.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        leftBubble.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftBubble.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        leftBubble.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -85).isActive = true
        leftBubble.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        greenBubble.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        greenBubble.widthAnchor.constraint(equalToConstant: 75).isActive = true
        greenBubble.heightAnchor.constraint(equalToConstant: 75).isActive = true
        greenBubble.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        checkmark.topAnchor.constraint(equalTo: greenBubble.topAnchor, constant: -10).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 68).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 64).isActive = true
        checkmark.leadingAnchor.constraint(equalTo: greenBubble.leadingAnchor, constant: 25).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: greenBubble.bottomAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: promptLabel.topAnchor, constant: -16).isActive = true
        
        promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        promptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
    }
    
    @objc private func pop() {
        navigationController?.popViewController(animated: true)
    }
}
