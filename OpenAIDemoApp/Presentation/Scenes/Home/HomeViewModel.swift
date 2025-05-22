//
//  HomeViewModel.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Dan Ilies on 20.02.2023.
//

import Foundation

protocol HomeDelegate: AnyObject {
    func logout()
}

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties and Init
    
    private weak var delegate: HomeDelegate?
    
    @Published var errorMessage: String?
    
    @Published var prompt = ""
    @Published var response = ""
    @Published var isLoading = false
    
    init(delegate: HomeDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Actions
    
    func sendRequest() {
        isLoading = true
        response = ""
        
        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            response = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Configuration.openAIApiKey())", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4.1",
            "input": prompt
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            response = "Error creating request: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.response = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.response = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let output = json["output"] as? [[String: Any]],
                       let firstOutput = output.first,
                       let contentArray = firstOutput["content"] as? [[String: Any]],
                       let firstContent = contentArray.first,
                       let text = firstContent["text"] as? String {
                        self.response = text
                    } else {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let error = json["error"] as? [String: Any],
                           let message = error["message"] as? String {
                            self.response = "API Error: \(message)"
                        } else {
                            self.response = "Unable to parse response"
                        }
                    }
                } catch {
                    self.response = "Error parsing response: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }
}
