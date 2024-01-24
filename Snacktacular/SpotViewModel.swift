//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 23/01/2024.
//

import Foundation
import FirebaseFirestore

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()// Ignore any error that shows up here. Wait for indexing. Clean built if it persist with shift+command+k. Error usually goes away with build+run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data delection, see 👉🏻 http://deriveddata.dance 👀
        
        if let id = spot.id { // spoit must already exist, so save.
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            } 
        } else { // no id? Then this must be a new spot to add
            do {
                try await db.collection("spots").addDocument(data: spot.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not createa new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    
}
