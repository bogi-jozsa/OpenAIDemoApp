//
//  AuthenticationCoordinator.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import UIKit

final class AuthenticationCoordinator: Coordinator {
    
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
        let loginViewController = viewFactory.getLoginViewController(delegate: self)
        self.navigationController.pushViewController(loginViewController, animated: false)
    }
    
}

extension AuthenticationCoordinator: LoginDelegate {
    func loginCompleted() {
        delegate?.flowFinished(coordinator: self)
    }
}
