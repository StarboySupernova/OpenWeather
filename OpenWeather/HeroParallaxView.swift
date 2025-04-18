//
//  HeroParallaxView.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import SwiftUI

struct HeroParallaxView: View {
    @State var translation: CGSize = .zero
    @State var isDragging = false
    @Binding var isAnimating: Bool
    var showDukeBackground: Bool = false
    var centreImage: String = ""
    
    var animation : Animation {
        .interpolatingSpring(stiffness: 0.5, damping: 0.5)
        .delay(isAnimating ? .random(in: 0...1) : 0)
        .speed(isAnimating ? .random(in: 0.3...1) : 0)
    }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                    stops: [
                    Gradient.Stop(color: Color(red: 0.45, green: 0.72, blue: 0.98), location: 0.00),
                    Gradient.Stop(color: Color("backgroundColor-1"), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0.12),
                    endPoint: UnitPoint(x: 0.5, y: 0.81)
                    )
                    .ignoresSafeArea()
                    
                    ZStack {
                        ForEach(1..<14, id: \.self) { index in
                            Image("food\(index % 7)")
                            //self positioning through geometry bounds
                                .position(x: .random(in: 0...geometry.size.width),
                                          y: .random(in: 0...geometry.size.height / 2)
                                )
                                .animation(animation, value: isAnimating)
                        }
                    }
                    .frame(height: geometry.size.height)

                    
                    Image("background1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 600)
                        .overlay(
                            ZStack {
                                if showDukeBackground {
                                    ZStack(alignment: .topLeading) {
                                        ZStack {}
                                            .frame(width: getRelativeWidth(240.0),
                                                   height: getRelativeHeight(307.0),
                                                   alignment: .leading)
                                            .background(RoundedCorners(topRight: 60.0,
                                                                       bottomRight: 40.0)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.45, green: 0.72, blue: 0.98).opacity(0.8),Color("backgroundColor-1").opacity(0.8)]),
                                                                     startPoint: .topLeading,
                                                                     endPoint: .bottomTrailing)))
                                            .shadow(color: Color.black, radius: 40,
                                                    x: 0, y: 20)
                                            .rotationEffect(.degrees(20))
                                        
                                        ZStack(alignment: .topTrailing) {
                                            VStack {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    
                                                    
                                                    
                                                }
                                                .frame(width: getRelativeWidth(199.0),
                                                       height: getRelativeHeight(229.0),
                                                       alignment: .center)
                                                .padding(.vertical, getRelativeHeight(20.53))
                                                .padding(.horizontal, getRelativeWidth(20.0))
                                                
                                                Text("")
                                                    .padding(.horizontal, getRelativeWidth(6.0))
                                                    .frame(width: getRelativeWidth(40.0),
                                                           height: getRelativeHeight(20.0),
                                                           alignment: .center)
                                                    .background(
                                                        Color("majenta")
                                                            .cornerRadius(10, corners: [.allCorners])
                                                    )
                                                    .padding(.vertical, getRelativeHeight(6.0))
                                            }
                                            
                                            
                                            Button(action: {}, label: {
                                                Image("pencil")
                                            })
                                            .frame(width: getRelativeWidth(32.0),
                                                   height: getRelativeWidth(32.0),
                                                   alignment: .center)
                                            .background(RoundedCorners(topLeft: 16.0,
                                                                       topRight: 16.0,
                                                                       bottomLeft: 16.0,
                                                                       bottomRight: 16.0)
                                                .fill(Color.black))
                                            
                                        }
                                        .overlay(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                                bottomRight: 40.0)
                                            .stroke(Color.white.opacity(0.2),
                                                    lineWidth: 1))
                                        .background(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                                   bottomRight: 40.0)
                                            .fill(Color.pink.opacity(0.4)))
                                        .shadow(radius: 40)
                                        .padding(.bottom, getRelativeHeight(28.0))
                                    }
                                }
                                
                                Image(centreImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120)
                                    .offset(x: translation.width/8, y: translation.height/15)
                                    
                                Image("logo2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400)
                                    .offset(x: translation.width/10, y: translation.height/20)
                                Image("logo3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 392, height: 600)
                                    .cornerRadius(50)
                                    .blendMode(.overlay)
                                    .offset(x: translation.width/15, y: translation.height/30)
                            }
                        )
                        .overlay(gloss1.blendMode(.softLight))
                        .overlay(
                            Image("gloss2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blendMode(.luminosity)
                                .mask(
                                    LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/100, y: translation.height/100))
                                        .frame(width: 392)
                                )
                        )
                        .overlay(gloss2.blendMode(.overlay))
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/10 - 10, y: abs(translation.height)/10 - 10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/10, y: translation.height/10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            // Outline
                            RoundedRectangle(cornerRadius: 50)
                                .strokeBorder(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.740428394)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7562086093)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.width/100 + 0.5, y: translation.height/100 + 0.5)))
                        )
                        .overlay {
                            LinearGradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.5152369619)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.4812706954))], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .blendMode(.overlay)
                                .cornerRadius(50)
                        }
                        .cornerRadius(50)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(.black)
                                .opacity(0.5)
                                .blur(radius: 50)
                                .offset(y: 50)
                                .blendMode(.overlay)
                        )
                        .scaleEffect(0.9)
                        .rotation3DEffect(.degrees(isDragging ? 10 : 0), axis: (x: -translation.height, y: translation.width, z: 0))
                        .gesture(drag)
                        .onTapGesture {
                            isAnimating = false
                        }
                }
                .onAppear {
                    isAnimating ? performDragAnimation() : nil
                }
            }
        }
        
        var drag: some Gesture {
            DragGesture()
                .onChanged { value in
                    translation = value.translation
                    isDragging = true
                }
                .onEnded { value in
                    withAnimation {
                        translation = .zero
                        isDragging = false
                    }
                }
        }
        
    var gloss1: some View {
        Image("gloss1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(-translation.height)/100+1, y: abs(-translation.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    var gloss2: some View {
        Image("gloss2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/100+1, y: abs(translation.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    func performDragAnimation() {
        withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
            let centre = (getRect().height * 0.2, getRect().width * 0.2)
               let radius: CGFloat = getRect().width
               let currentTime = Date().timeIntervalSince1970
               let angle = CGFloat(currentTime) * 2 * .pi / 10.0 // Adjust the divisor to control the speed of rotation

            let x = radius * cos(angle) / centre.0
            let y = radius * sin(angle) * getRect().height * 0.002
               
               translation = CGSize(width: x, height: y)
           }
    }
}

struct HeroParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        HeroParallaxView(isAnimating: .constant(false))
    }
}

struct ParallaxPlaceholderView: View {
    @State var translation: CGSize = .zero
    @State var isDragging = false
    @State var isAnimating: Bool = true
    var frameHeight: Double = 600
    var frameWidth: Double? = nil
    
    var animation : Animation {
        .interpolatingSpring(stiffness: 0.5, damping: 0.5)
        .delay(isAnimating ? .random(in: 0...1) : 0)
        .speed(isAnimating ? .random(in: 0.3...1) : 0)
    }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Image("background1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: frameHeight)
                        .overlay(
                            ZStack {
                                Image("logo2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180)
                                    .opacity(0.1)
                                    .offset(x: translation.width/8, y: translation.height/15)
                                Image("logo2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400)
                                    .offset(x: translation.width/10, y: translation.height/20)
                                Image("logo3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 392, height: frameHeight)
                                    .cornerRadius(50)
                                    .blendMode(.overlay)
                                    .offset(x: translation.width/15, y: translation.height/30)
                            }
                        )
                        .overlay(gloss1.blendMode(.softLight))
                        .overlay(
                            Image("gloss2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blendMode(.luminosity)
                                .mask(
                                    LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/100, y: translation.height/100))
                                        .frame(width: 392)
                                )
                        )
                        .overlay(gloss2.blendMode(.overlay))
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/10 - 10, y: abs(translation.height)/10 - 10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.height/10, y: translation.height/10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            // Outline
                            RoundedRectangle(cornerRadius: 50)
                                .strokeBorder(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.740428394)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7562086093)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: translation.width/100 + 0.5, y: translation.height/100 + 0.5)))
                        )
                        .overlay {
                            LinearGradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.5152369619)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.4812706954))], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .blendMode(.overlay)
                                .cornerRadius(50)
                        }
                        .cornerRadius(50)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(.black)
                                .opacity(0.5)
                                .blur(radius: 50)
                                .offset(y: 50)
                                .blendMode(.overlay)
                        )
                        .scaleEffect(0.9)
                        .rotation3DEffect(.degrees(isDragging ? 10 : 0), axis: (x: -translation.height, y: translation.width, z: 0))
                        .gesture(drag)
                        .onTapGesture {
                            isAnimating = false
                        }
                }
                .frame(width: frameWidth ?? 200)
                .onAppear {
                    isAnimating ? performDragAnimation() : nil
                }
            }
        }
        
        var drag: some Gesture {
            DragGesture()
                .onChanged { value in
                    translation = value.translation
                    isDragging = true
                }
                .onEnded { value in
                    withAnimation {
                        translation = .zero
                        isDragging = false
                    }
                }
        }
        
    var gloss1: some View {
        Image("gloss1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(-translation.height)/100+1, y: abs(-translation.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    var gloss2: some View {
        Image("gloss2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(translation.height)/100+1, y: abs(translation.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    func performDragAnimation() {
        withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
            let centre = (getRect().height * 0.2, getRect().width * 0.2)
               let radius: CGFloat = getRect().width
               let currentTime = Date().timeIntervalSince1970
               let angle = CGFloat(currentTime) * 2 * .pi / 10.0 // Adjust the divisor to control the speed of rotation

            let x = radius * cos(angle) / centre.0
            let y = radius * sin(angle) * getRect().height * 0.002
               
               translation = CGSize(width: x, height: y)
           }
    }
}

