//
//  Spot.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 23/01/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    
    var name = ""
    var address = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address]
    }
    
}
