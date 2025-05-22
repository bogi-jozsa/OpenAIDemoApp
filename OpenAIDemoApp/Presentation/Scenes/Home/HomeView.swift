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
        VStack(spacing: 20) {
            Text("OpenAI Chat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextEditor(text: $viewModel.prompt)
                .frame(height: 100)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
            
            Button(action: viewModel.sendRequest) {
                Text(viewModel.isLoading ? "Loading..." : "Send Request")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(viewModel.isLoading)
            
            if !viewModel.response.isEmpty {
                ScrollView {
                    Text(viewModel.response)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
