//
//  Buttons.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import SwiftUI

// MARK: - Primary

struct PrimaryButtonStyle: ButtonStyle {
    
    @Binding var isLoading: Bool
    
    let icon: ImageResource?
    let customColor: Color?
    let customTextColor: Color?
    let activityIndicatorColor: UIColor?
    
    init(isLoading: Binding<Bool> = .constant(false), icon: ImageResource? = nil, customColor: Color? = nil,
         customTextColor: Color? = nil, activityIndicatorColor: UIColor? = nil) {
        self._isLoading = isLoading
        self.icon = icon
        self.customColor = customColor
        self.customTextColor = customTextColor
        self.activityIndicatorColor = activityIndicatorColor
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        return CustomButton(
            isLoading: $isLoading, configuration: configuration,
            minHeight: 55, fontSize: 16, cornerRadius: 12, icon: icon,
            customColor: customColor, customTextColor: customTextColor,
            activityIndicatorColor: activityIndicatorColor)
    }
}

struct CustomButton: View {
    @Environment(\.isEnabled) var isEnabled
    @Binding var isLoading: Bool
    
    let configuration: ButtonStyle.Configuration
    
    let minHeight: CGFloat
    let fontSize: CGFloat
    let cornerRadius: CGFloat
    let icon: ImageResource?
    var customColor: Color?
    var customTextColor: Color?
    var activityIndicatorColor: UIColor?
    
    var body: some View {
        return ZStack(alignment: .leading) {
            hStackBody
            
            if let icon = self.icon {
                Image(icon)
                    .frame(width: 34)
                    .padding(.leading, 28)
            }
        }
        .allowsHitTesting(!isLoading)
    }
    
    private var hStackBody: some View {
        return HStack {
            Spacer()
            
            if isLoading {
                CustomActivityIndicator(tintColor: activityIndicatorColor ?? .white)
                    .frame(minHeight: minHeight)
            } else {
                configuration.label
                    .foregroundColor(customTextColor ?? Color.appWhiteFC)
                    .frame(minHeight: minHeight, alignment: .center)
                    .font(.appBold(size: fontSize))
            }
            
            Spacer()
        }
        .background(isEnabled ? (self.customColor ?? Color.gray) : Color.gray).opacity(configuration.isPressed ? 0.8 : 1)
        .cornerRadius(cornerRadius)
    }
}
