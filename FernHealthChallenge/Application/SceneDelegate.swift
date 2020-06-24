//
//  SceneDelegate.swift
//  FernHealthChallenge
//
//  Created by Arturo Reyes on 6/19/20.
//  Copyright © 2020 Arturo Reyes. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(navigationController)
        appCoordinator?.start()
    }

}

