//
//  Rolled.swift
//  DiceRoller
//
//  Created by Nick Rice on 18/10/2021.
//

import SwiftUI

class Rolls: ObservableObject {
    @Published private(set) var all: [Roll]
    
    static let shared = Rolls()
    
    init() {
        self.all = []
    }
    
    func add(_ roll: Roll) {
        all.append(roll)
    }
    
    func reset() {
        self.all = []
    }
}

struct Roll: Identifiable {
    let id = UUID()
    var firstDice: Int
    var secondDice: Int
    let createdAt = Date()
}

//class Rolled: ObservableObject {
//    var id = UUID()
//    var diceOne: Int = 1
//    var diceTwo: Int = 2
//}
//
//class DiceRolled: ObservableObject {
//    @Published private var diceRolled: [Rolled]
//    static let saveKey = "SavedData"
//
//    init() {
//        let filename = Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
//
//        do {
//            let data = try Data(contentsOf: filename)
//            self.diceRolled = try JSONDecoder().decode([Rolled].self, from: data)
//            return
//        } catch {
//            print("Unable to load saved data.")
//        }
//
//        self.diceRolled = []
//    }
//
//    private func save() {
//        do {
//            let filename = Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
//            let data = try JSONEncoder().encode(self.diceRolled)
//            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
//        } catch {
//            print("Unable to save data.")
//        }
//    }
//
//    private static func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func add(_ roll: Rolled) {
//        diceRolled.append(roll)
//        save()
//    }
//}
