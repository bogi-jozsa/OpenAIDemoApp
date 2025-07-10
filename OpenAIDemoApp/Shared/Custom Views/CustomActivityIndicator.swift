//
//  CustomActivityIndicator.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import UIKit
import SwiftUI

struct CustomActivityIndicator: UIViewRepresentable {
    
    let tintColor: UIColor
    let style: UIActivityIndicatorView.Style
    
    init(tintColor: UIColor = .white, style: UIActivityIndicatorView.Style = .medium) {
        self.tintColor = tintColor
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.color = self.tintColor
        view.style = self.style
        view.hidesWhenStopped = true
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
}


struct DotLoadingView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .foregroundStyle(Color.gray)
                    .frame(width: 10, height: 10)
                    .scaleEffect(animate ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
