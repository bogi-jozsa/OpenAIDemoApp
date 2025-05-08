//
//  HomeView.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: HomeViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text("Home screen")
                .headerTwo()
                .padding(.bottom, 20)
            
            if let error = viewModel.errorMessage {
                errorMessageView(message: error)
            } else {
                List(viewModel.items) { item in
                    Text("\(item.id) - \(item.content)")
                }.padding(.bottom, 20)
            }
            
            Button {
                viewModel.logout()
            } label: {
                Text("Logout")
            }
            
        }.onAppear {
            viewModel.getDemoItems()
        }
    }
    
    func errorMessageView(message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
            Spacer()
        }.padding(.horizontal, 20)
    }
}

// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
