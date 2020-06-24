//
//  ViewController.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit
import Combine

/// Delegate that informs when the code has been validated or if the validation failed
protocol CodeAuthViewControllerDelegate: class {
    func didAuthenticateCode()
    func didFailAuth()
}

final class CodeAuthViewController: UIViewController {
    
    // MARK: Delegates
    weak var delegate: CodeAuthViewControllerDelegate?
    
    // MARK: ViewModel
    private let viewModel: CodeAuthViewModel
    
    // MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .left
        label.text = LocalizedString("title")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = LocalizedString("prompt")
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .darkGreen
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.text = LocalizedString("full_program_message")
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    private let feedbackTextAttributes: [NSAttributedString.Key:Any?] = {
        var attributes = [NSAttributedString.Key:Any?]()
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        attributes[.font] = font
        attributes[.foregroundColor] = UIColor.darkGreen
        return attributes
    }()
    
    private let feedbackView: UIView = {
        let view = UIView()
        view.backgroundColor = .rose
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedString("continue"), for: .normal)
        button.setTitleColor(.darkGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 30
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    private let rightBubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "right_bubble"))
        image.tintColor = .bubbleGreen
        image.alpha = 0.1
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let leftBubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "left_bubble"))
        image.tintColor = .bubbleGreen
        //image.alpha = 0.1
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let codeStackView: CodeStackView
    private var activityIndicator: ActivityIndicatorView?
    
    
    // MARK: Data subscribers
    private var codeValueSubscriber: AnyCancellable?
    private var codeSubscriber     : AnyCancellable?
    
    // MARK: Init methods
    init(codeValidator: CodeAuthenticator) {
        self.viewModel = CodeAuthViewModel(codeValidator: codeValidator)
        self.codeStackView = CodeStackView(codeLength: codeValidator.codeLength, labelWidth: 40)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Superclass methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGreen
        navigationController?.setTransparentBar()
        
        // Set up layout
        setupLayout()
        
        // Set subscribers
        dataBinding()
        
        // Set targets
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        // Set delegates
        codeStackView.delegate = self
        
        // Show keyboard
        codeStackView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: UIImageView(image: UIImage(named: "left_arrow"))), animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    
    // MARK: Private methods
    
    /// Sets subviews layout using AutoLayout
    private func setupLayout() {
        
        // Normally, I would have used a framework for this task, such as SnapKit or Cartography, since
        // they help the code look cleaner. However, I did it fully native in here for the purposes of this challenge.
        
        view.addSubview(titleLabel)
        view.addSubview(promptLabel)
        view.addSubview(codeStackView)
        view.addSubview(continueButton)
        
        view.insertSubview(rightBubble, at: 0)
        view.insertSubview(leftBubble, at: 1)
        
        rightBubble.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightBubble.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightBubble.heightAnchor.constraint(equalToConstant: 238).isActive = true
        rightBubble.widthAnchor.constraint(equalToConstant: 193).isActive = true
        
        
        leftBubble.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftBubble.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        leftBubble.heightAnchor.constraint(equalToConstant: 330).isActive = true
        leftBubble.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: promptLabel.topAnchor, constant: -18).isActive = true
    
        promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        promptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        promptLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        promptLabel.bottomAnchor.constraint(equalTo: codeStackView.topAnchor, constant: -36).isActive = true
        
        codeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        codeStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -38).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        feedbackView.addSubview(feedbackTextView)
        view.addSubview(feedbackView)
        
        feedbackTextView.topAnchor.constraint(equalTo: feedbackView.topAnchor).isActive = true
        feedbackTextView.leadingAnchor.constraint(equalTo: feedbackView.leadingAnchor, constant: 10).isActive = true
        feedbackTextView.trailingAnchor.constraint(equalTo: feedbackView.trailingAnchor, constant: -10).isActive = true
        feedbackTextView.bottomAnchor.constraint(equalTo: feedbackView.bottomAnchor).isActive = true
        
        feedbackView.topAnchor.constraint(equalTo: codeStackView.bottomAnchor, constant: 30).isActive = true
        feedbackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        feedbackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        feedbackView.bottomAnchor.constraint(lessThanOrEqualTo: continueButton.topAnchor, constant: 30).isActive = true
        feedbackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

    }
    
    /// Binds the views to our ViewModel objects using Combine
    private func dataBinding() {
        // Actions to perform when the user inputs a code
        codeValueSubscriber = viewModel.$codeValue.receive(on: DispatchQueue.main).sink { [weak self] codeValue in
            guard let self = self else { return }
            guard let codeValue = codeValue else { return }
            self.handleCode(codeValue)
        }
        
        // Actions to perform when the user types in a new character
        codeSubscriber = viewModel.$code.receive(on: DispatchQueue.main).sink { [weak self] code in
            guard let self = self else { return }
            let isComplete = code.count == self.viewModel.codeValidator.codeLength
            self.continueButton.isEnabled = isComplete
            if !isComplete {
                self.feedbackView.isHidden = true
            }
        }
        
        // Stop Activity indicator after request is completed and display error if request failed
        viewModel.didCompleteRequest = { completion in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicator?.stopAnimating()
                
                switch completion {
                case .failure(let error):
                    self.feedbackTextView.text = error.localizedDescription
                    self.feedbackView.isHidden = false
                default:
                    break
                }
            }
        }
        
    }
    
    /// Authenticate code when user taps continue
    @objc private func didTapContinue() {
        activityIndicator = ActivityIndicatorView()
        activityIndicator!.addIn(view: view)
        activityIndicator!.startAnimating()
        viewModel.authenticate()
    }
    
    /**
     Handles UI updates when a new code value is generated from the user's input
     - Parameter codeValue: An enum of the different responses to give the user from the given code (invalid, valid or full program)
     */
    private func handleCode(_ codeValue: CodeValue) {
        switch codeValue {
        case .invalid:
            let attributedText = NSAttributedString(string: LocalizedString(codeValue.descriptionKey), attributes: feedbackTextAttributes as [NSAttributedString.Key:Any])
            feedbackTextView.attributedText = attributedText
            feedbackView.isHidden = false
        case .fullProgram:
            let message = LocalizedString(codeValue.descriptionKey)
            let supportEmail = LocalizedString("support_email")
            let supportMessage = message + supportEmail
            let attributedString = NSMutableAttributedString(string: supportMessage, attributes: feedbackTextAttributes as [NSAttributedString.Key:Any])
            
            // Email link attributes
            let emailLinkRange = NSRange(location: message.count, length: supportEmail.count)
            attributedString.addAttribute(.link, value: "mailto:\(supportEmail)", range: emailLinkRange)
            var emailLinkAttributes = [NSAttributedString.Key:Any]()
            emailLinkAttributes[.font] = UIFont.boldSystemFont(ofSize: 16)
            emailLinkAttributes[.foregroundColor] = UIColor.darkGreen
            emailLinkAttributes[.underlineColor] = UIColor.darkGreen
            emailLinkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            
            feedbackTextView.linkTextAttributes = emailLinkAttributes
            feedbackTextView.attributedText = attributedString
            feedbackView.isHidden = false
            
        case .valid:
            // If valid, inform the delegate
            feedbackView.isHidden = true
            delegate?.didAuthenticateCode()
        }
    }
}

// MARK: CodeStackViewDelegate
extension CodeAuthViewController: CodeStackViewDelegate {
    
    func didInputCode(_ codeStackView: CodeStackView, codeString: String) {
        viewModel.code = codeString
    }
    
    func didEnterNonAlphaNumeric(_ codeStackView: CodeStackView) {
        let attributedText = NSAttributedString(string: LocalizedString("alphanumeric_message"), attributes: feedbackTextAttributes as [NSAttributedString.Key:Any])
        feedbackTextView.attributedText = attributedText
        feedbackView.isHidden = false
    }
    
}
