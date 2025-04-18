//
//  Extensions.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import Foundation
import SwiftUI
import CoreGraphics

public extension CGFloat {
    /// 4
    static let small: CGFloat = 4
    /// 8
    static let medium: CGFloat = 8
    /// 16
    static let large: CGFloat = 16
    /// 24
    static let xLarge: CGFloat = 24
    /// 32
    static let xxLarge: CGFloat = 34
    /// 42
    static let xxxLarge: CGFloat = 42
}

// Extension for rounded Double to 0 decimals
extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(self)
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// returns screen size
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

extension Image {
    
    /// Resize an image with fill aspect ratio and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    func resizedToFill(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fit aspect ratio and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    func resizedToFit(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fill aspect ratio, customizable aspect ratio value (default: 4/3) and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    ///     - aspectRatio: value to pass to aspectRatio, if any
    func resizedToFillAspectRatio(width: CGFloat, height: CGFloat, aspectRatio: CGFloat = 4/3) -> some View {
        self
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fill)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fit aspect ratio, customizable aspect ratio value (default: 4/3) and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    ///     - aspectRatio: value to pass to aspectRatio, if any
    func resizedToFitAspectRatio(width: CGFloat, height: CGFloat, aspectRatio: CGFloat = 4/3) -> some View {
        self
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(width: width, height: height)
    }
}


