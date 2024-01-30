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
    
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State var selectedPhoto = Photo()
    
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
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }
                        
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(photo: $selectedPhoto, uiImage: uiImage, spot: spot)
        }
    }
}

#Preview {
    SpotDetailPhotosScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-66618.appspot.com/o/4Lic0qY1sx1M1ghzC7aW%2F0C767B8D-F0F5-4AB9-95E9-D4F73ACB0B6C.jpeg?alt=media&token=f2205fac-5d33-4a71-bec8-7a1bbdd0ba8b")], spot: Spot(id: "4Lic0qY1sx1M1ghzC7aW"))
}
