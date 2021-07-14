//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Nick Rice on 01/07/2021.
//

import SwiftUI
import Network

struct CheckoutView: View {
    @ObservedObject var order = Order()
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var hasConnection = true
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcake")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        
                    VStack {
                        Text("Your delivery address:")
                            .padding(.bottom, 8)
            
                        Text("\(order.name)")
                            .fontWeight(.semibold)
                        Text("\(order.streetAddress)")
                            .fontWeight(.semibold)
                        Text("\(order.city)")
                            .fontWeight(.semibold)
                        Text("\(order.postcode)")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(width: 340)
                    .background(ContainerRelativeShape().fill(Color("cardGray")))
                    .cornerRadius(8)
                    .padding()

                    HStack {
                        Text("Your total is £\(self.order.cost, specifier: "%.2f")")
                            .font(Font.system(size: 24))
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 340)
                            .background(ContainerRelativeShape().fill(Color("cardGray")))
                            .cornerRadius(8)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 400)
                            .frame(width: 340, height: 70)
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            self.placeOrder()
                        }, label: {
                            HStack {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 22, weight: .regular))
                                Text("Place order")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 18, weight: .semibold))
                            }
                        })
                        .padding()
                    }
                    .offset(y: 100)
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            self.checkInternetConnection()
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // Challenge 2
        if hasConnection {
            sendData(url: URL(string: "https://reqres.in/api/cupcakes")!, encoded: encoded)
        } else {
            alertTitle = "Connection error"
            alertMessage = "Please enable WiFi or cellular data."
            showingAlert = true
        }
    }
        
    func sendData(url: URL, encoded: Data) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank you!"
                self.alertMessage = "Your order for \(decodedOrder.quantity) \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingAlert = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    func checkInternetConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.hasConnection = true
            } else {
                self.hasConnection = false
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
