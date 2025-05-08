//
//  Coordinator.swift
//
//  Created by Vica Cotoarba on 20.09.2021.
//

import UIKit

// MARK: - CoordinatorDelegate

protocol CoordinatorDelegate: AnyObject {
    func flowFinished<T: Coordinator>(coordinator: T)
}

// MARK: - Coordinator

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var delegate: CoordinatorDelegate? { get set }
    
    func start()
    func cleanup()
}

extension Coordinator {
    func cleanup() {
        self.navigationController.dismiss(animated: false) { [weak self] in
            self?.navigationController.viewControllers.forEach({ $0.removeFromParent() })
            self?.navigationController.viewControllers = []
        }
    }
}
