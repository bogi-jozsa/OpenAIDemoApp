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
    @State private var showConversationList = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                headerView
                chatContentView
                inputView
            }
            .padding()
            .sheet(isPresented: $showConversationList) {
                ConversationListView(viewModel: viewModel, isPresented: $showConversationList)
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack {
            Button(action: {
                showConversationList = true
            }) {
                Text("History")
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            VStack {
                Text("My Chat")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let currentConversation = viewModel.currentConversation {
                    Text(currentConversation.title)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.createNewConversation()
            }) {
                Text("New Chat")
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Chat Content View
    
    private var chatContentView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.chatMessages) { message in
                        ChatMessageView(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 8)
            }
            .onChange(of: viewModel.chatMessages.count) { _ in
                if let lastMessage = viewModel.chatMessages.last {
                    withAnimation(.easeOut(duration: 0.3)) {
                        scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    // MARK: - Input View
    
    private var inputView: some View {
        VStack(spacing: 12) {
            TextEditor(text: $viewModel.prompt)
                .frame(minHeight: 60, maxHeight: 120)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if viewModel.prompt.isEmpty {
                            Text("Type your message...")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.leading, 16)
                                .padding(.top, 12)
                        }
                    },
                    alignment: .topLeading
                )
            
            Button(action: {
                Task {
                    await viewModel.sendRequest()
                }
            }) {
                Text(viewModel.isLoading ? "Sending..." : "Send Message")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isLoading || viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(viewModel.isLoading || viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

// MARK: - Chat Message View

struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User message
            if let request = message.requestString, !request.isEmpty {
                HStack {
                    Spacer()
                    Text(request)
                        .padding(12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                }
            }
            
            // AI response
            if let response = message.responseString, !response.isEmpty {
                HStack {
                    Text(response)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                    Spacer()
                }
            }
            
            // Timestamp
            Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Conversation List View

struct ConversationListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.conversations) { conversation in
                    ConversationRowView(conversation: conversation) {
                        viewModel.switchToConversation(conversation)
                        isPresented = false
                    }
                }
                .onDelete(perform: deleteConversations)
            }
            .navigationTitle("Chat History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        viewModel.clearAllHistory()
                        isPresented = false
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func deleteConversations(offsets: IndexSet) {
        for index in offsets {
            let conversation = viewModel.conversations[index]
            viewModel.deleteConversation(conversation)
        }
    }
}

// MARK: - Conversation Row View

struct ConversationRowView: View {
    let conversation: Conversation
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text("\(conversation.messages.count) messages")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(conversation.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
