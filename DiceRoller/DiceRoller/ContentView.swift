//
//  ContentView.swift
//  DiceRoller
//
//  Created by Nick Rice on 18/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RollView()
                .tabItem {
                    Image(systemName: "die.face.6")
                    Text("Roll")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
