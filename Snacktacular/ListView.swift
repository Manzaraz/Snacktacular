//
//  ListView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 23/01/2024.
//

import SwiftUI
import Firebase

struct ListView: View {
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        List {
            Text("List items will go here")
        }
        .listStyle(.plain)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("🪵➡️ Log Out successful!")
                        dismiss()
                    } catch {
                        print("😡 ERROR: Could not sign out!")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    sheetIsPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                SpotDetailView(spot: Spot())
            }
        }
    }
}

#Preview {
    NavigationStack {
        
        ListView()
    }
}
