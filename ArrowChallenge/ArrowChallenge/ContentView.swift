//
//  ContentView.swift
//  ArrowChallenge
//
//  Created by Nick Rice on 10/06/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Flower()) {
                    Image(systemName: "1.square")
                    Text("Flower")
                }
                
                NavigationLink(destination: SpecialEffects()) {
                    Image(systemName: "2.square")
                    Text("Special Effects")
                }
                
                NavigationLink(destination: RGB()) {
                    Image(systemName: "3.square")
                    Text("RGB")
                }
                
                NavigationLink(destination: Trapezoid()) {
                    Image(systemName: "4.square")
                    Text("Trapezoid")
                }
                
                NavigationLink(destination: Spirograph()) {
                    Image(systemName: "5.square")
                    Text("Spirograph")
                }
                
                NavigationLink(destination: Arrow()) {
                    Image(systemName: "6.square")
                    Text("Arrow")
                }
                
                NavigationLink(destination: ColorSquare()) {
                    Image(systemName: "7.square")
                    Text("Color Square")
                }
            }
            .navigationBarTitle(Text("Drawing"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
