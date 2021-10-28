//
//  Resort.swift
//  SnowSeeker
//
//  Created by Nick Rice on 21/10/2021.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    var wrappedSize: String {
        switch size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    var wrappedPrice: String {
        String(repeating: "$", count: price)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
    
    static var countries: Set<String> {
        Set(allResorts.map { $0.country })
    }
    
    static let wrappedSizes = ["Small", "Average", "Large"]
    
    static var wrappedPrices: Set<String> {
        Set(allResorts.map { $0.wrappedPrice })
    }
}
