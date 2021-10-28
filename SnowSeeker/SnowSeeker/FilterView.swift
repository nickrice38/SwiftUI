//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Nick Rice on 27/10/2021.
//

import SwiftUI

struct FilterView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var filter: Filter

  @State private var country = "All"
  @State private var sortOrder = 0
  @State private var size = "All"
  @State private var price = "All"
  let sortTypes = ["All", "Name", "Country"]

  private var filterSortOrder: Filter.SortType {
    switch self.sortOrder {
    case 1:
      return .name
    case 2:
      return .country
    default:
      return .none
    }
  }

  private var selectedSortOrder: Int {
    switch self.filter.sortOrder {
    case .name:
      return 1
    case .country:
      return 2
    default:
      return 0
    }
  }

  private var countries: [String] {
    ["All"] + Array(Resort.countries).sorted()
  }

  private var sizes: [String] {
    ["All"] + Resort.wrappedSizes
  }

  private var prices: [String] {
    ["All"] + Resort.wrappedPrices.sorted()
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: HStack {
          Image(systemName: "arrow.up.arrow.down")
          Text("Sort by")
        }) {
          Picker("Sort order", selection: $sortOrder) {
            ForEach(0 ..< sortTypes.count) {
              Text(self.sortTypes[$0])
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section(header: HStack {
          Image(systemName: "flag")
          Text("Filter by country")
        }) {
          Picker("Country", selection: $country) {
            ForEach(self.countries, id: \.self) {
              Text("\($0)")
            }
          }
        }

        Section(header: HStack {
          Image(systemName: "textformat.size")
          Text("Filter by size")
        }) {
          Picker("Size", selection: $size) {
            ForEach(self.sizes, id: \.self) {
              Text("\($0)")
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }

        Section(header: HStack {
          Image(systemName: "sterlingsign.circle")
          Text("Filter by price")
        }) {
          Picker("Price", selection: $price) {
            ForEach(self.prices, id: \.self) {
              Text("\($0)")
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
      }
      .navigationBarItems(trailing: Button("Done") {
        self.filter.setSortOrder(self.filterSortOrder)
        self.filter.country = self.country
        self.filter.size = self.size
        self.filter.price = self.price
        self.presentationMode.wrappedValue.dismiss()
      })
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear(perform: {
      self.sortOrder = self.selectedSortOrder
      self.country = self.filter.country
      self.size = self.filter.size
      self.price = self.filter.price
    })
  }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
