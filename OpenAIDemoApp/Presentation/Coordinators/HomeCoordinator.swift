//
//  AuthenticationCoordinator.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import UIKit
import SwiftUI

final class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    weak var delegate: CoordinatorDelegate?
    private var viewFactory: ViewFactoryProtocol
    
    // MARK: - Init and Start
    
    init(navigationController: UINavigationController, viewFactory: ViewFactoryProtocol, delegate: CoordinatorDelegate? = nil) {
        self.navigationController = navigationController
        self.viewFactory = viewFactory
        self.delegate = delegate
    }
    
    func start() {
        self.navigationController.navigationBar.isHidden = true
        let homeViewController = viewFactory.getHomeViewController(delegate: self)
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
}

// MARK: - Delegates

extension HomeCoordinator: HomeDelegate {
    
    func logout() {
        self.delegate?.flowFinished(coordinator: self)
    }
    
}
