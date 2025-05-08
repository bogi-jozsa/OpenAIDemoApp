//
//  ViewExtensions.swift
//  WolfpackDigitalSwiftUIBaseProject
//
//  Created by Vica Cotoarba on 30.06.2022.
//

import SwiftUI

extension View {
  func hideKeyboardWhenTappedAround(didHide: (() -> Void)? = nil) -> some View {
    return self.onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      didHide?()
    }
  }
}
