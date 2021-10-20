//
//  HistoryView.swift
//  DiceRoller
//
//  Created by Nick Rice on 18/10/2021.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var rolls = Rolls.shared
    
    @State private var showingResetAlert = false
    
    var sortedRolls: [Roll] {
        self.rolls.all.sorted(by: { $0.createdAt > $1.createdAt })
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.sortedRolls) { roll in
                    HStack {
                        Image("Dice\(roll.firstDice)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        
                        Image("Dice\(roll.secondDice)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        
                        Spacer()
                        
                        Text("Total: ")
                            .font(Font.system(size: 24, weight: .regular))
                            .padding(.leading, 16)
                            
                        
                        Text("\(roll.firstDice + roll.secondDice)")
                            .font(Font.system(size: 24, weight: .bold))
                            .padding(.trailing, 16)
                            
                    }
                }
            }
            .navigationBarTitle("Recent Rolls")
            .navigationBarItems(trailing: Button(action: {
                self.showingResetAlert = true
              }) {
                Image(systemName: "arrow.counterclockwise")
              }
              .disabled(self.sortedRolls.count == 0)
            )
            .alert(isPresented: $showingResetAlert) {
              Alert(
                title: Text("Reset recent rolls"),
                message: Text("Are you sure you want to reset recent rolls?"),
                primaryButton: .destructive(Text("Reset")) { self.resetRecentRolls() },
                secondaryButton: .cancel()
                )
            }
        }
    }
    
    func resetRecentRolls() {
        self.rolls.reset()
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(roll: Rolled)
//    }
//}
