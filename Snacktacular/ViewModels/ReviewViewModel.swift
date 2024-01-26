//
//  ReviewViewModel.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 25/01/2024.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()// Ignore any error that shows up here. Wait for indexing. Clean built if it persist with shift+command+k. Error usually goes away with build+run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data delection, see 👉🏻 http://deriveddata.dance 👀
        
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id = nil")
            return false
        }
        
        let collectionString = "spots/\(spotID)/reviews"
        
        if let id = review.id { // review must already exist, so save.
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else { // no id? Then this must be a new review to add
            do {
                try await db.collection(collectionString).addDocument(data: review.dictionary)
//                _  = try await db.collection(collectionString).addDocument(data: review.dictionary)

                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        guard let spotID = spot.id, let reviewID = review.id else {
            print("😡 ERROR: spot.id = \(spot.id ?? "nil"), review.id = \(review.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("spots").document(spotID).collection("reviews").document(reviewID).delete()
            print("🗑️ Document successfully deleted.")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
    
}
