//
//  AppCoordinator.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

/// The top flow coordinator in the coordinator's hierarchy
final class AppCoordinator: Coordinator {
    
    weak var outputDelegate: CoordinatorOutput?
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showAuthFlow()
    }
    
    func finish() {}
    
}

extension AppCoordinator {
    
    private func showAuthFlow() {
        let authFlowCoordinator = AuthCoordinator.init(navigationController)
        authFlowCoordinator.outputDelegate = self
        authFlowCoordinator.start()
        childCoordinators.append(authFlowCoordinator)
    }
    
    private func showMainFlow() {
        // Move to App's main flow when auth has been successful
    }
}

extension AppCoordinator: CoordinatorOutput {
    
    func coordinatorDidFinish(coordinator: Coordinator) {
        removeChild(coordinator)
        
        if coordinator is AuthCoordinator {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
}
