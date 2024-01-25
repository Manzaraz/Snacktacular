//
//  ReviewView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 25/01/2024.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @StateObject var reviewVM = ReviewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack (alignment: .leading){
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                .lineLimit(1)
                
                Text(spot.address)
                    .padding(.bottom)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Click to Rate: ")
                .font(.title2)
                .bold()
            
            HStack {
                StarsSelecitonView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            .padding(.bottom)
            
            VStack (alignment: .leading) {
                Text("Review Title: ")
                    .bold()
                TextField("title", text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(05), lineWidth: 2)
                    }
                
                Text("Review")
                    .bold()
                
                TextField("review", text: $review.body, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(05), lineWidth: 2)
                    }
            }
            .padding(.horizontal)
            .font(.title2)
            
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        let success = await reviewVM.saveReview(spot: spot,review: review)
                        if success {
                            dismiss()
                        } else {
                            print("😡 ERROR: Saving data in ReviewView")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boylestone St., Chesnut Hill, MA 02467"), review: Review())
    }
}
