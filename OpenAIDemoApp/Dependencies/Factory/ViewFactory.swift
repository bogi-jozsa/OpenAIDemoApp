//
//  ViewFactory.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import SwiftUI

protocol ViewFactoryProtocol {
    func getLoginViewController(delegate: LoginDelegate) -> UIViewController
    func getHomeViewController(delegate: HomeDelegate) -> UIViewController
}


final class ViewFactory: ViewFactoryProtocol {
    
    // MARK: - Factory Methods
    
    func getLoginViewController(delegate: LoginDelegate) -> UIViewController {
        let viewModel = LoginViewModel(delegate: delegate)
        let loginView = LoginView(viewModel: viewModel)
        return UIHostingController(rootView: loginView)
    }
    
    func getHomeViewController(delegate: HomeDelegate) -> UIViewController {
        let viewModel = HomeViewModel(delegate: delegate)
        let homeView = HomeView(viewModel: viewModel)
        return UIHostingController(rootView: homeView)
    }
    
}
