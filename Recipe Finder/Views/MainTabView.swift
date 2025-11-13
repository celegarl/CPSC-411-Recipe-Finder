//
//  MainTabView.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/08/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Add ingredients input tab (button to enter ingredients)
            AddIngredientsView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Ingredients")
                }
                .tag(0)
            
            // Landing Page / Home Tab
            LandingPageView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            
            // Recipes Display Tab
            RecipesDisplayView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Recipes")
                }
                .tag(2)
            
            // Learn More Tab
            LearnMoreView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("Learn More")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
}
