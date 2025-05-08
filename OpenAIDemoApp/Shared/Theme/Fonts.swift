//
//  Fonts.swift
//
//  Created by Vica Cotoarba on 21.09.2021.
//

import SwiftUI

// MARK: - App Fonts

extension Font {
    
    static func appRegular(size: CGFloat) -> Font {
        return Font.system(size: size).weight(.regular)
    }
    
    static func appBold(size: CGFloat) -> Font {
        return Font.system(size: size).weight(.bold)
    }
    
    static func appSemiBold(size: CGFloat) -> Font {
        return Font.system(size: size).weight(.semibold)
    }
    
    static func appMedium(size: CGFloat) -> Font {
        return Font.system(size: size).weight(.medium)
    }
    
    static func appLight(size: CGFloat) -> Font {
        return Font.system(size: size).weight(.light)
    }
}

extension UIFont {
    
    static func appRegular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func appBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func appSemiBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func appMedium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func appLight(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
}

// MARK: - Custom Font Settings

extension Text {
    
    func headerOne() -> Text {
        self.font(.appSemiBold(size: 72))
    }
    
    func headerTwo() -> Text {
        self.font(.appSemiBold(size: 40))
    }
    
    func headerThree() -> Text {
        self.font(.appSemiBold(size: 32))
    }
    
    func bodyLarge() -> Text {
        self.font(.appRegular(size: 18))
    }
    
    func bodyRegular() -> Text {
        self.font(.appRegular(size: 16))
    }
    
    func bodySmall() -> Text {
        self.font(.appRegular(size: 14))
    }
    
    
    func bodyBoldSmall() -> Text {
        self.font(.appSemiBold(size: 10))
    }
}
