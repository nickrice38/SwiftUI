//
//  Prospect.swift
//  HotProspects
//
//  Created by Nick Rice on 23/09/2021.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    let dateAdded = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    init() {
        let filename = Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)

      do {
        let data = try Data(contentsOf: filename)
        self.people = try JSONDecoder().decode([Prospect].self, from: data)
        return
      } catch {
            print("Unable to load saved data.")
      }

      self.people = []
    }
    
    private func save() {
        do {
          let filename = Self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
          let data = try JSONEncoder().encode(self.people)
          try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
      }
    
    private static func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
