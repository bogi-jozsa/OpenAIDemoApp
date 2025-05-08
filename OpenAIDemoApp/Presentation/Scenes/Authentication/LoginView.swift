//
//  LoginView.swift
//
//  Created by Vica Cotoarba on 17.09.2021.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: LoginViewModel
    
    // MARK: - Body
    
    var body: some View {
        if viewModel.isLoading {
            CustomActivityIndicator(
                tintColor: .black,
                style: .large
            )
        } else {
            contents
        }
    }
    
    // MARK: - Views
    
    var contents: some View {
        return VStack {
            Text("Welcome!")
                .headerTwo()
            Spacer()
            Button {
                viewModel.performLogin()
            } label: {
                Text("Login")
                    .padding()
            }
            Spacer()
        }
    }
}

// MARK: - Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
