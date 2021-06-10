//
//  SpecialEffects.swift
//  ArrowChallenge
//
//  Created by Nick Rice on 10/06/2021.
//

import SwiftUI

struct SpecialEffects: View {
    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Image("sonny")
                .resizable()
                .scaledToFit()
                .saturation(Double(amount))
                .blur(radius: (1 - amount) * 20)
            
            Slider(value: $amount)
                .padding()
                .offset(y: 200)
        }
        .navigationBarTitle("Special Effects", displayMode: .inline)
    }
}

struct SpecialEffects_Previews: PreviewProvider {
    static var previews: some View {
        SpecialEffects()
    }
}
