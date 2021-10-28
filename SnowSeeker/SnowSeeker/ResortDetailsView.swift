//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Nick Rice on 21/10/2021.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort: Resort
    
    var size: String {
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    var price: String {
        String(repeating: "£", count: resort.price)
    }
    
    var body: some View {
        Group {
            Text("Size: \(resort.wrappedSize)").layoutPriority(1)
            Spacer().frame(height: 0)
            Text("Price: \(resort.wrappedPrice)").layoutPriority(1)
        }
    }
}

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}
