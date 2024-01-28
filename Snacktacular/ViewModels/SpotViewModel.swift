//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 23/01/2024.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor

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
                let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not createa new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id == nil")
            return false
        }
        
        let photoName = UUID().uuidString //  This will be the name of the image file
        let storage = Storage.storage() // Create a Firebase Storage instance.
        let storageRef = storage.reference().child("\(spotID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡 ERROR: Could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser. This setting will work for png as well as jpeg
        var imageURLString = "" // We'll set this after the image is successfully saved
        
        do {
            let _ = try await storageRef.putData(resizedImage, metadata: metadata)
            print("📸 Image Saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // We'll save this Cloud Firestore as part of document in "photos" collection, below
            } catch {
                print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return false
            }
        } catch {
            print("😡 ERROR: uploading image to FirebaseStorage")
            return false
        }
        
        // Now save to the "photos" collection of the spot document spotID
        
        let db = Firestore.firestore()
        let collectionString = "spots/\(spotID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("😎📸 Data updated successfully!")
            return true
        } catch {
            print("😡 ERROR: Could not update data in 'photos' for spotID \(spotID)")
            return false
        }
    }
}
