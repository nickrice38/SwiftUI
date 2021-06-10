//
//  Arrow.swift
//  ArrowChallenge
//
//  Created by Nick Rice on 10/06/2021.
//

import SwiftUI

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY * 1/3))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 1/3))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY * 2/3))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 2/3))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 1/3))
        
        return path
    }
}

struct Arrow: View {
    
    @State private var lineThickness: CGFloat = 10
    
    var body: some View {
        ArrowShape()
            .stroke(Color.blue, style: StrokeStyle(lineWidth: lineThickness, lineCap: .round, lineJoin: .round))
            .frame(width: 200, height: 200)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    self.lineThickness = CGFloat.random(in: 3...30)
                }
        }
            .navigationBarTitle("Arrow", displayMode: .inline)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        ArrowShape()
    }
}
