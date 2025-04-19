//
//  PermissionView.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import SwiftUI
import CoreLocationUI
import MapKit
import Resolver


struct PermissionView: View {
    @Environment(\.colorScheme) var colorScheme
    @InjectedObject var homeViewModel: HomeViewModel
    @State private var isAnimating: Bool = false
    @State private var showMap: Bool = false
    let action : () -> Void
    let dismissAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(alignment: .center) {
                Spacer()
                
                VStack {
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
                                    Text("Welcome To")
                                        .font(FontScheme
                                            .kRobotoCondensedMedium(size: getRelativeHeight(13.0)))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: getRelativeWidth(69.0),
                                               height: getRelativeHeight(16.0),
                                               alignment: .topLeading)
                                        .padding(.trailing)
                                    
                                    Text("OpenWeather")
                                        .font(.largeTitle)
                                        .fontWeight(.ultraLight)
                                        .padding(.bottom, .large)
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black,
                                                radius: 40, x: 0, y: 20)
                                        .padding(.top, getRelativeHeight(10.0))
                                        .padding(.trailing, getRelativeWidth(10.0))
                                    Text("Weather at your fingertips")
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.leading)
                                        
                                    HStack {
                                        Button(action: {}, label: {
                                            Image("insight")
                                        })
                                        .frame(width: getRelativeWidth(31.0),
                                               height: getRelativeHeight(32.0),
                                               alignment: .center)
                                        .background(RoundedCorners(topLeft: 16.0,
                                                                   topRight: 16.0,
                                                                   bottomLeft: 16.0,
                                                                   bottomRight: 16.0)
                                            .fill(Color.black))
                                        Text("Worldwide Coverage")
                                            .font(FontScheme
                                                .kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(width: getRelativeWidth(141.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .leading)
                                    .padding(.top, getRelativeHeight(8.0))
                                    .padding(.trailing, getRelativeWidth(10.0))
                                    
                                    HStack {
                                        Button(action: {}, label: {
                                            Image("search")
                                        })
                                        .frame(width: getRelativeWidth(31.0),
                                               height: getRelativeHeight(32.0),
                                               alignment: .center)
                                        .background(RoundedCorners(topLeft: 16.0,
                                                                   topRight: 16.0,
                                                                   bottomLeft: 16.0,
                                                                   bottomRight: 16.0)
                                            .fill(Color.black))
                                                                        
                                        Text("All Locations")
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.leading)
                                            .minimumScaleFactor(0.5)
                                            .frame(width: getRelativeWidth(107.0),
                                                   height: getRelativeHeight(16.0),
                                                   alignment: .topLeading)
                                            .padding(.top, getRelativeHeight(8.0))
                                            .padding(.bottom, getRelativeHeight(7.0))
                                        
                                    }
                                    .frame(width: getRelativeWidth(199.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .leading)
                                    .padding(.top, getRelativeHeight(10.0))
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

                .padding()
                
                Spacer()
                
                GradientButton(buttonTitle: "Get Started") {
                    action()
                }
                .padding()
                .frame(width: geometry.size.width * 0.7)
                .shadow(radius: 10)
            }
            .frame(maxWidth: getRect().width * 0.95)
        }
        .background(
            Image("img_waves_1152x768")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height,
                       alignment: .topLeading)
                .scaledToFit()
                .clipped()
        )
        .background(
            HeroParallaxView(isAnimating: $isAnimating)
                .opacity(0.9)
        )
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView() {} dismissAction: {}
            .preferredColorScheme(.light)
    }
}
