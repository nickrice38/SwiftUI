//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Nick Rice on 01/07/2021.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Postcode", text: $order.postcode)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    HStack {
                        Image(systemName: "cart").foregroundColor(Color.blue)
                        Text("Checkout")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
