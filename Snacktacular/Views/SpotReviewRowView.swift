//
//  SpotReviewRowView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 25/01/2024.
//

import SwiftUI

struct SpotReviewRowView: View {
    @State var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title)
                .font(.title2)
            HStack {
                StarsSelecitonView(rating: $review.rating, interactive: false, font: .callout)
                Text(review.body)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    SpotReviewRowView(review: Review(title: "Fantastic Food!", body: "I love this place so much. The only thing preventing 5 stars is the surley service", rating: 4))
}
