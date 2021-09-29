//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Nick Rice on 23/09/2021.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }

    enum FilterStyle {
        case name, recent
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var showingSortOptions = false
    @State private var filterStyle : FilterStyle = .name
    
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case.contacted:
            return "Contacted people"
        case.uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        let filterOrder = filterStyle == .name ? prospects.people.sorted { $0.name < $1.name } : prospects.people.sorted { $0.dateAdded > $1.dateAdded }
        
        switch filter {
        case .none:
            return filterOrder
        case .contacted:
            return filterOrder.filter { $0.isContacted }
        case .uncontacted:
            return filterOrder.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if self.filter == .none {
                            Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                                .padding(.trailing)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            
            .actionSheet(isPresented: $showingSortOptions) { () -> ActionSheet in
                ActionSheet(title: Text("Sort Contacts"), buttons: [
                    .default(Text("Sort by name")) { self.filterStyle = .name },
                    .default(Text("Sort by date added")) { self.filterStyle = .recent },
                    .cancel()
                ])
            }
            
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button("Sort") {
                self.showingSortOptions.toggle()
                }, trailing: Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
            
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: self.generateSimulatedData(), completion: self.handleScan)
            }
        }
    }
    
    func generateSimulatedData() -> String {
        let firstNames = ["Ron", "Andy", "Leslie", "April", "Tom", "Ben", "Chris", "Anne", "Jerry"]
        let lastNames = ["Swanson", "Dwyer", "Knope", "Ludgate", "Haverford", "Wyatt", "Traeger", "Perkins", "Gergich"]
        let firstName = firstNames[Int.random(in: 0..<firstNames.count)]
        let lastName = lastNames[Int.random(in: 0..<lastNames.count)]
        let email = "\(firstName.lowercased())@\(lastName.lowercased()).com"
        
        return "\(firstName) \(lastName)\n\(email)"
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            //            var dateComponents = DateComponents()
            //            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Doh!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
