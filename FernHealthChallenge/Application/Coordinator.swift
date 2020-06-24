//
//  Coordinator.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

/// Protocol for Flow Coordinator objects that control the navigation flow
protocol Coordinator: class {
    init(_ navigationController: UINavigationController)
    
    // The delegate that is notified after the navigation of this coordinator has come to an end
    var outputDelegate: CoordinatorOutput? { get set }
    // The top navigation controller in the hierarchy of view controllers within this flow coordinator
    var navigationController: UINavigationController { get set }
    // The child coordinators that would be in charge of any sub-flow inside this coordinator hierarchy
    var childCoordinators: [Coordinator] { get set }
    
    // Actions to perform to start the navigation
    func start()
    // Actions to perform to end the navigation
    func finish()
}

/// Protocol for the objects responsible for performing some action after a flow coordinator has finished its navigation
protocol CoordinatorOutput: class {
    func coordinatorDidFinish(coordinator: Coordinator)
}


extension Coordinator {
    /**
     Removes a child coordinator from the coordinator children array
     - Parameter coordinator: The child coordinator to remove
     */
    func removeChild(_ coordinator: Coordinator) {
        for (index, object) in childCoordinators.enumerated() {
            if object === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}



