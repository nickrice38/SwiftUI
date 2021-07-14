//
//  ContentView.swift
//  Habitrack
//
//  Created by Nick Rice on 14/06/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.offWhite
                
                List {
                    ForEach(activities.items) { item in
                        NavigationLink(destination: SecondView(activities: self.activities, activity: item)) {
                            Text(item.name).font(Font.custom("Rubik-Medium", size: 17))
                            Spacer()
                            Text("\(item.completed)").font(Font.custom("Rubik-Medium", size: 17))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .colorMultiply(.offWhite)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Habitrack")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {
                        self.showingAddActivity = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
            .sheet(isPresented: $showingAddActivity) {
                AddNewActivity(activities: self.activities)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
