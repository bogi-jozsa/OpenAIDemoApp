//
//  SceneDelegate.swift
//
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // Custom Properties
    private var appCoordinator: AppCoordinator?
    private var dependencyContainer: DependencyContainer?
    private var viewFactory: ViewFactoryProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            self.dependencyContainer = AppDependencyContainer()
            
            let viewFactory: ViewFactoryProtocol = ViewFactory()
            self.viewFactory = viewFactory
            
            let coordinator = AppCoordinator(window: window, viewFactory: viewFactory)
            self.appCoordinator = coordinator
            
            coordinator.start()
        }
    }

}
