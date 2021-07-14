//
//  ActivityStruct.swift
//  Habitrack
//
//  Created by Nick Rice on 15/06/2021.
//

import Foundation

struct ActivityStruct: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    var completed: Int = 0
}
