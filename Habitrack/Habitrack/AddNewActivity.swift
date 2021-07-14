//
//  AddNewActivity.swift
//  Habitrack
//
//  Created by Nick Rice on 14/06/2021.
//

import SwiftUI

struct AddNewActivity: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var activities: Activities
    
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name).font(Font.custom("Rubik-Regular", size: 17))
                TextField("Description", text: $description).font(Font.custom("Rubik-Regular", size: 17))
            }
            .navigationBarTitle("Add Activity")
            .navigationBarItems(trailing:
                Button("Add") {
                    let item = ActivityStruct(name: self.name, description: self.description)
                    self.activities.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
    
                }
            )
        }
        .colorMultiply(.offWhite)
    }
}

struct AddNewActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddNewActivity(activities: Activities())
    }
}
