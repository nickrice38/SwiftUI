//
//  ContentView.swift
//  WeSplit
//
//  Created by Nick Rice on 22/03/2021.
//  Copyright © 2021 Nick Rice. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeopleStr = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [0, 10, 15, 20, 25]
    
    var billTotal: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeopleStr) ?? 1
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .padding(.horizontal, 0.0)
                        .keyboardType(.decimalPad)
                    TextField("Number of people", text: $numberOfPeopleStr)
                        .keyboardType(.decimalPad)
                }
//                    Picker("Number of people", selection: $numberOfPeople) {
//                        ForEach(2 ..< 100) {
//                            Text("\($0) people")
//                        }
        
                Section(header: Text("How much tip do you want to leave?").font(.system(size: 16.0, weight: .regular))) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .padding(.horizontal, 0.0)
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(height: 50)
                }
                .textCase(.none) // to make section headers sentence case
                
                Section(header: Text ("Bill total").font(.system(size: 16.0, weight: .regular))) {
                    Text("£\(billTotal, specifier: "%.2f")")
                }
                .textCase(.none) // to make section headers sentence case
                
                Section(header: Text ("Total per person").font(.system(size: 16.0, weight: .regular))) {
                    Text("£\(totalPerPerson, specifier: "%.2f")")
                }
                .textCase(.none) // to make section headers sentence case
        }   .navigationBarTitle("WeSplit")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
