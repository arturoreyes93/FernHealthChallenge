//
//  CodeStackView.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

/// CodeStackView Delegate to inform about the user inputs
protocol CodeStackViewDelegate: class {
    func didInputCode(_ codeStackView: CodeStackView, codeString: String)
    func didEnterNonAlphaNumeric(_ codeStackView: CodeStackView)
}

/// Custom Stack View to display the user's code input
final class CodeStackView: UIStackView {
    
    // MARK: Delegate
    weak var delegate: CodeStackViewDelegate?
    
    // MARK: Private properties
    
    // The amount of arranged subviews in the stackview
    private let codeLength: Int
    
    // The labels that display each character individually
    private var codeLabels: [UILabel] = []
    
    // Helper to ensure only alphanumeric values are input by the user
    private let nonAlphaNumericCharacters = NSCharacterSet.alphanumerics.inverted
    
    // Recognizer that detects when user taps on the view to input characters
    private var recognizer: UITapGestureRecognizer?
    
    // The current index of the code labels array at which the new character is to be set
    private var currentIndex: Int {
        var index = 0
        for label in codeLabels {
            if let text = label.text {
                if text.isEmpty {
                    return index
                }
            } else {
                return index
            }
            
            index += 1
        }
        
        return index
    }
    
    // To be able to use the keyboard
    override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: Initializer
    
    /**
     Custom Initializer
     - Parameter codeLength: Integer to determine how many label to add to the stack view
     - Parameter labelWidth: CGFloat value for the width of each label
     */
    init(codeLength: Int, labelWidth: CGFloat) {
        self.codeLength = codeLength
        super.init(frame: .zero)
        distribution = .fill
        spacing = 8
        axis = .horizontal
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set subviews
        for _ in 0..<codeLength {
            let label = codeLabel()
            let wrapperView = UIView()
            wrapperView.backgroundColor = .white
            wrapperView.layer.cornerRadius = 6
            wrapperView.addSubview(label)
            wrapperView.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
            addArrangedSubview(wrapperView)
            codeLabels.append(label)
        }
        
        // Set tap recognizer
        recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(recognizer!)
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    @objc private func didTap() {
        becomeFirstResponder()
    }
    
    /**
     Called everytime the keyboard inputs a new character. It checks that the character
     is an alphanumeric value, otherwise it informs the delegate.
     - Parameter ch: The single length string for the character input by the user using the keyboard
     */
    private func didAddCharacter(_ ch: String) {
        guard currentIndex < codeLabels.count else { return }
        
        guard ch.components(separatedBy: nonAlphaNumericCharacters).joined(separator: "") == ch else {
            delegate?.didEnterNonAlphaNumeric(self)
            return
        }

        codeLabels[currentIndex].text = ch
        codeUpdated()
    }
    
    /// Called everytime the user deletes a character
    private func didDeleteCharacter() {
        guard currentIndex > 0 else { return }
        codeLabels[currentIndex-1].text = ""
        codeUpdated()
    }
    
    /// Refactor UILabel creation
    private func codeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// Called everytime the code is updated by the user
    private func codeUpdated() {
        var codeString = ""
        for label in codeLabels {
            if let ch = label.text, ch.count == 1 {
                codeString += ch
            }
        }
        
        // Inform the delegate that a new code was input by the user
        delegate?.didInputCode(self, codeString: codeString)
        
        // Remove keyboard if code is complete
        if codeString.count == codeLength {
            resignFirstResponder()
        }
    }
}

// MARK: UIKeyInput Protocol
/// UIKeyInput protocol to handle the keyboard input
extension CodeStackView: UIKeyInput {
    
    var hasText: Bool {
        for label in codeLabels {
            if let text = label.text, !text.isEmpty {
                return true
            }
        }
        return false
    }
    
    func insertText(_ text: String) {
        if text == "\n" && currentIndex == codeLength {
            resignFirstResponder()
        } else {
            didAddCharacter(text)
        }
    }
    
    func deleteBackward() {
        didDeleteCharacter()
    }
    
        
}
