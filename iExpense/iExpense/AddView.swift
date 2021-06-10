//
//  AddView.swift
//  iExpense
//
//  Created by Nick Rice on 18/05/2021.
//

import SwiftUI

struct AddView: View {
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert = true
                }
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Please enter a valid amount"), message: Text("You can only enter a number Please try again."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
