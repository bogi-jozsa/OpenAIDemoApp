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
        NavigationView {
            VStack(spacing: 20) {
                
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.getChatHistory()
                        }
                    }) {
                        Text("Previous chat")
                            .fontWeight(.medium)
                            .padding(4)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Text("My Chat")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                        }
                    }) {
                        Text("New chat")
                            .fontWeight(.medium)
                            .padding(4)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                TextEditor(text: $viewModel.prompt)
                    .frame(height: 70)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await viewModel.sendRequest()
                    }
                }) {
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
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.chatMessages, id: \.self) { message in
                                ChatMessageView(message: message)
                            }
                        }
                    }
                    .onChange(of: viewModel.chatMessages.count) { _ in
                        withAnimation {
                            scrollProxy.scrollTo(0, anchor: .top)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        VStack(alignment: .leading) {
            Text(message.requestString ?? "")
                .padding()
                .background(Color.gray)
                .cornerRadius(8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(message.responseString ?? "")
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
