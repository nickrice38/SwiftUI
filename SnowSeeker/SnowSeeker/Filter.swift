//
//  Filter.swift
//  SnowSeeker
//
//  Created by Nick Rice on 27/10/2021.
//

import SwiftUI

class Filter: ObservableObject {
    enum SortType {
        case none, name, country
    }
    
    var sortOrder: SortType = .none
    var country = "All"
    var size = "All"
    var price = "All"
    
    func setSortOrder(_ newSortOrder: SortType) {
        objectWillChange.send()
        self.sortOrder = newSortOrder
    }
}
