//
//  GradientButton.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//


import SwiftUI

struct GradientButton: View {
    var buttonTitle: String
    var width: CGFloat?
    var height: CGFloat = 50
    var buttonAction: () -> Void
    var gradient1: [Color] = [
        Color(red: 101/255, green: 134/255, blue: 1),
        Color(red: 1, green: 64/255, blue: 80/255),
        Color(red: 109/255, green: 1, blue: 185/255),
        Color(red: 39/255, green: 232/255, blue: 1)
    ]
    @State private var angle: Double = 0
    
    var body: some View {
        Button(action: buttonAction) {
            GeometryReader { geometry in
                ZStack {
                    AngularGradient(gradient: Gradient(colors: gradient1), center: .center, angle: .degrees(angle))
                        .blendMode(.overlay)
                        .blur(radius: 8.0)
                        .mask (
                            RoundedRectangle(cornerRadius: 16)
                                .frame(maxWidth: width ?? geometry.size.width * 0.7)
                                .frame(height: height)
                                .blur(radius: 8)
                        )
                        .onAppear {
                            withAnimation(.linear(duration: 7)) {
                                self.angle += 350
                            }
                        }
                    GradientText(text: buttonTitle)
                        .font(.headline)
                        .frame(maxWidth: width ?? geometry.size.width * 0.7)
                        .frame(height: height)
                        .background(Color("tertiaryBackground").opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16.0)
                                .stroke(Color.white, lineWidth: 1.0)
                                .blendMode(.normal)
                                .opacity(0.7)
                        )
                        .cornerRadius(16.0)
                }
            }
        }
        .frame(height: height)
    }
}

struct GradientButton_Previews: PreviewProvider {
    static var previews: some View {
        GradientButton(buttonTitle: "Hello") {
            print("yy")
        }
        .preferredColorScheme(.dark)
    }
}
