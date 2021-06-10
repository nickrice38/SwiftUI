//
//  Trapezoid.swift
//  ArrowChallenge
//
//  Created by Nick Rice on 10/06/2021.
//

import SwiftUI

struct TrapezoidShape: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))

        return path
    }
}

struct Trapezoid: View {
    @State private var insetAmount: CGFloat = 50
    
    var body: some View {
        TrapezoidShape(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    self.insetAmount = CGFloat.random(in: 10...90)
                }
            }
            .navigationBarTitle("Trapezoid", displayMode: .inline)
    }
}

struct Trapezoid_Previews: PreviewProvider {
    static var previews: some View {
        Trapezoid()
    }
}
