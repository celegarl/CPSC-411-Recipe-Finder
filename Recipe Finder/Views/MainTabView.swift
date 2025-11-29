//
//  MainTabView.swift
//  Recipe Finder
//
//  Created by Guido Asbun on 11/08/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {

            // Add ingredients input tab (button to enter ingredients)
            AddIngredientsView(viewModel: recipeViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Ingredients")
                }
                .tag(0)

            // Recipe List view
            RecipesDisplayView(viewModel: recipeViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Recipes")
                }
                .tag(1)

            // Landing Page / Home Tab
            LandingPageView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)

            // Favorites Tab
            FavoritesView(viewModel: favoritesViewModel)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
}
