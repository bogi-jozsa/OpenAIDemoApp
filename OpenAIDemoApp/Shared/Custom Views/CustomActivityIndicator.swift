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
