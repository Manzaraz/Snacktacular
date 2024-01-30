//
//  SpotDetailPhotosScrollView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 29/01/2024.
//

import SwiftUI

struct SpotDetailPhotosScrollView: View {
//    struct FackePhoto: Identifiable {
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-66618.appspot.com/o/4Lic0qY1sx1M1ghzC7aW%2F0C767B8D-F0F5-4AB9-95E9-D4F73ACB0B6C.jpeg?alt=media&token=f2205fac-5d33-4a71-bec8-7a1bbdd0ba8b"
//    }
    
//    let photos = [FackePhoto(), FackePhoto(), FackePhoto(),FackePhoto(), FackePhoto(),FackePhoto(),FackePhoto(), FackePhoto()]
    
    var photos: [Photo]
    var spot: Spot
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4) {
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            // Order is important here!
                            .frame(width: 80, height: 80)
                            .scaledToFill()
                            .clipped()
                        
                    } placeholder: {
                        ProgressView()
                    }

                    
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
    }
}

#Preview {
    SpotDetailPhotosScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-66618.appspot.com/o/4Lic0qY1sx1M1ghzC7aW%2F0C767B8D-F0F5-4AB9-95E9-D4F73ACB0B6C.jpeg?alt=media&token=f2205fac-5d33-4a71-bec8-7a1bbdd0ba8b")], spot: Spot(id: "4Lic0qY1sx1M1ghzC7aW"))
}
