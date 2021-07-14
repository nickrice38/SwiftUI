//
//  ActivityClass.swift
//  Habitrack
//
//  Created by Nick Rice on 15/06/2021.
//

import Foundation

class Activities: ObservableObject {
    @Published var items = [ActivityStruct]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ActivityStruct].self, from: items) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

