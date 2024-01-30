//
//  PhotoView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 29/01/2024.
//

import SwiftUI
import Firebase

struct PhotoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM: SpotViewModel
    @Binding var photo: Photo
    var uiImage: UIImage
    var spot: Spot
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!(Auth.auth().currentUser?.email == photo.reviewer))
                
                Text("by \(photo.reviewer) on \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
            }
            .padding()
            .toolbar {
                if Auth.auth().currentUser?.email == photo.reviewer {
                    // Image was posted by current user
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .automatic) {
                        Button("Save") {
                            Task {
                                let success = await spotVM.saveImage(spot: spot, photo: photo, image: uiImage)
                                if success {
                                    
                                    dismiss()
                                }
                            }
                        }
                    }
                } else {
                    // Image was NOT posted by current user
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
               
            }
        }
    }
}

#Preview {
    PhotoView(photo: .constant(Photo()), uiImage: UIImage(named: "pizza") ?? UIImage(), spot: Spot())
        .environmentObject(SpotViewModel())
}
