//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Nick Rice on 20/10/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var favourites = Favourites()
    @ObservedObject var filter = Filter()
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var showingFilterView = false
    
    var filteredResorts: [Resort] {
        var result = resorts
        
        if filter.country != "All" {
            result = result.filter( { $0.country == filter.country } )
        }
        
        if filter.size != "All" {
            result = result.filter( { $0.wrappedSize == filter.size })
        }
        
        if filter.price != "All" {
            result = result.filter( { $0.wrappedPrice == filter.price })
        }
        
        return result
    }
    
    var sortedResorts: [Resort] {
        switch filter.sortOrder {
        case .none:
            return filteredResorts
        case .name:
            return filteredResorts.sorted(by: { $0.name < $1.name })
        case .country:
            return filteredResorts.sorted(by: { $0.country < $1.country })
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favourites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favourite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing: Button(action: {
                self.showingFilterView = true
            }) {
                Image(systemName: "arrow.up.arrow.down")
            })
            
            WelcomeView()
        }
        
        .environmentObject(favourites)
        .sheet(isPresented: $showingFilterView) {
            FilterView()
                .environmentObject(self.filter)
        }
//        .phoneOnlyStackNavigationView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
