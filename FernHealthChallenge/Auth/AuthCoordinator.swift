//
//  AuthCoordinator.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit


final class AuthCoordinator: Coordinator {
    
    weak var outputDelegate: CoordinatorOutput?

    var childCoordinators = [Coordinator]()
    
    unowned var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        // This flow starts with the Code Authenticator Controller
        showCodeAuth()
    }
    
    func finish() {
        outputDelegate?.coordinatorDidFinish(coordinator: self)
    }
}

extension AuthCoordinator {
    
    private func showCodeAuth() {
        let authViewController = CodeAuthViewController()
        authViewController.delegate = self
        navigationController.show(authViewController, sender: self)
    }
}


extension AuthCoordinator: CodeAuthViewControllerDelegate {
    
    func didAuthenticateCode() {
        // After code has been validated, push to FeedbackViewController.
        // By controlling the flow in the Coordinator, we enforce data encapsulation so view controller's don't know anything about each other
        let feedbackVC = FeedbackViewController()
        navigationController.pushViewController(feedbackVC, animated: true)
    }
    
    func didFailAuth() {
        // Handle navigation when auth failed
    }
    
    
}

