//
//  ContentView.swift
//  Conversion
//
//  Created by Nick Rice on 25/03/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var inputAmount = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    
    let nameOfUnits: [String] = ["m", "km", "ft", "yd", "mi"]
    let actualUnits: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
    
    var convertedValue: Double {
        if let value = Double(inputAmount) {
            let userEntered = Measurement(value: value, unit: actualUnits[inputUnit])
            return userEntered.converted(to: actualUnits[outputUnit]).value
        }
        return 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("From")) {
                    HStack {
                        TextField("Enter your measurement", text: $inputAmount)
                            .keyboardType(.decimalPad)
                        Text("Meters")
                    }
                    Picker("Unit", selection: $inputUnit) {
                        ForEach(0 ..< nameOfUnits.count) {
                            Text("\(self.nameOfUnits[$0])")
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("To")) {
                    HStack {
                        Text("\(convertedValue, specifier: "%.3f")")
                    }
                    
                    Picker("Unit", selection: $outputUnit) {
                        ForEach(0 ..< nameOfUnits.count) {
                            Text("\(self.nameOfUnits[$0])")
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                }
                
//                Section(header: Text("Output")) {
//                    Text("\(convertedValue, specifier: "%.3f")")
//                }
//
                
                
                
            } .navigationBarTitle("Length Convertor")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
