//
//  GradientText.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import SwiftUI

struct GradientText: View {
    var text: String = "Text here"
    var boldFontModifiersEnabled: Bool = false
    var gradientColors: [Color]? = nil
    var fontSize: CGFloat? = nil
    var lineLimit: Int? = nil
    
    var body: some View {
        Text(text)
            .if(boldFontModifiersEnabled, transform: { thisView in
                thisView
                    .font(.system(size: fontSize ?? 30, weight: .bold))
                    .fontWeight(.bold)
            })
            .if(lineLimit != nil, transform: { thisView in
                thisView
                    .multilineTextAlignment(.leading)
                    .lineLimit(lineLimit!)
            })
            .gradientForeground(colors: gradientColors ?? [Color(#colorLiteral(red: 0.6196078431, green: 0.6784313725, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5607843137, blue: 0.9803921569, alpha: 1))])
    }
}



struct GradientText_Previews: PreviewProvider {
    static var previews: some View {
        GradientText()
    }
}
