//
//  ColorSquare.swift
//  ArrowChallenge
//
//  Created by Nick Rice on 10/06/2021.
//

import SwiftUI

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorSquare: View {
    @State private var colorCycyle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: self.colorCycyle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycyle)
        }
        .padding()
        .navigationBarTitle("Color Square", displayMode: .inline)
    }
}

struct ColorSquare_Previews: PreviewProvider {
    static var previews: some View {
        ColorSquare()
    }
}
