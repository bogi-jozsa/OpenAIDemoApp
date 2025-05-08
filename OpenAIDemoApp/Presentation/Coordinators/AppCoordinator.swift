//
//  AppCoordinator.swift
//
//  Created by Vica Cotoarba on 20.09.2021.
//

import UIKit
import SwiftUI

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
        
    private var window: UIWindow!
    private var currentCoordinator: Coordinator!
    private var viewFactory: ViewFactoryProtocol
    
    var navigationController: UINavigationController
    weak var delegate: CoordinatorDelegate?
    
    // MARK: - Init and Start
    
    init(window: UIWindow, viewFactory: ViewFactoryProtocol) {
        self.window = window
        self.viewFactory = viewFactory
        self.navigationController = UINavigationController()
    }
    
    func start() {
        self.setUIDefaults()
        self.navigateToHome()
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Navigation
    
    private func navigateToLogin(animated: Bool = false) {
        let authCoordinator = AuthenticationCoordinator(
            navigationController: UINavigationController(),
            viewFactory: viewFactory,
            delegate: self
        )
        self.startNewCoordinator(authCoordinator)
    }
    
    private func navigateToHome(animated: Bool = false) {
        let homeCoordinator = HomeCoordinator(
            navigationController: UINavigationController(),
            viewFactory: self.viewFactory,
            delegate: self
        )
        self.startNewCoordinator(homeCoordinator)
    }
    
    // MARK: - Initial Setup
    
    private func setUIDefaults() {
        
    }
    
    private func startNewCoordinator(_ coordinator: Coordinator, animated: Bool = false) {
        coordinator.start()
        self.currentCoordinator = coordinator
        self.navigationController = coordinator.navigationController
        self.replaceRoot(viewController: coordinator.navigationController, animated: animated)
    }
    
    private func replaceRoot(viewController: UIViewController, animated: Bool) {
        if animated {
            var options = UIWindow.TransitionOptions(direction: .toRight, style: .easeInOut)
            options.background = UIWindow.TransitionOptions.Background.solidColor(.white)
            self.window.setRootViewController(viewController, options: options)
        } else {
            self.window.rootViewController = viewController
        }
    }
}


// MARK: - Delegates

extension AppCoordinator: CoordinatorDelegate {
    func flowFinished<T>(coordinator: T) where T: Coordinator {
        if coordinator is HomeCoordinator {
            navigateToLogin(animated: false)
        } else if coordinator is AuthenticationCoordinator {
            navigateToHome(animated: true)
        }
        coordinator.cleanup()
    }
}
