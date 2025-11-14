//
//  LandingPageView.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/10/25.
//

import SwiftUI

struct LandingPageView: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Cooking icon
            Image(systemName: "fork.knife")
                .font(.system(size: 80))
                .foregroundColor(.primary)

            // Welcome text
            VStack(spacing: 10) {
                Text("Welcome to")
                    .font(.title)
                Text("Recipe Finder iOS")
                    .font(.title)
                    .bold()
            }

            Spacer()

            // Action buttons
            VStack(spacing: 20) {
                Button(action: {
                    selectedTab = 0 // Navigate to Ingredients tab
                }) {
                    Text("Enter Ingredients")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                Button(action: {
                    selectedTab = 3 // Navigate to Learn More (will add this)
                }) {
                    Text("Learn More")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}

#Preview {
    LandingPageView(selectedTab: .constant(1))
}
