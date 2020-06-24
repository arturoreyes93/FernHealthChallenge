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
        // This flow starts with the CodeValidatorViewController
        showCodeValidator()
    }
    
    func finish() {
        outputDelegate?.coordinatorDidFinish(coordinator: self)
    }
}

extension AuthCoordinator {
    
    private func showCodeValidator() {
        // Use dependency injection to inject network routers for testing requests
        // 1. Inject a URLSession to the network router
        // 2. Inject the Network Router to the CodeAuthenticatorService
        // 3. Injet the CodeAuthenticatorService to the CodeAuthViewController
        let codeValidator = CodeAuthenticatorService(networkRouter: StatusCodeRouter(session: URLSession.shared))
        let authViewController = CodeAuthViewController(codeValidator: codeValidator)
        authViewController.delegate = self
        navigationController.show(authViewController, sender: self)
    }
}


extension AuthCoordinator: CodeAuthViewControllerDelegate {
    
    func didAuthenticateCode() {
        // After code has been validated, push to FeedbackViewController.
        //By controlling the flow in the Coordinator, we enforce data encapsulation so view controller's don't know anything about each other
        let feedbackVC = FeedbackViewController()
        navigationController.pushViewController(feedbackVC, animated: true)
    }
    
    func didFailAuth() {
        // Handle when auth failed
    }
    
    
}

