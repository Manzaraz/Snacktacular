//
//  StarsSelecitonView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 25/01/2024.
//

import SwiftUI

struct StarsSelecitonView: View {
    @Binding var rating: Int // change this to @Binding after layout is tested
    @State var interactive = true
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    var font: Font = .largeTitle
    let fillColor: Color = .red
    let emptyColor: Color = .gray
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundStyle(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        if interactive {
                            rating = number
                        }
                    }
            }
            .font(font)
        }
    }
    
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

#Preview {
    StarsSelecitonView(rating: .constant(4))
}
