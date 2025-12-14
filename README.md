# CPSC-411-Recipe-Finder

Recipe Finder is an iOS app built with **SwiftUI** that generates recipes based on ingredients that you already have. It uses the **OpenAI API** to create structured recipe results and **DALL-E-3** to generate matching food images.

---

## Features
- Enter and manage an ingredients list
- Generate multiple recipe ideas using OpenAI (JSON-based output)
- Auto-generate recipe images with DALL-E-3
- View full recipe details (steps, ingredients, etc.)
- Save and manage favorite recipes (persistent)

---

## Tech Stack
- **Swift / SwiftUI**
- **MVVM architecture**
- **Async/Await + TaskGroup** for parallel image generation
- **UserDefaults** for favorites persistence
- **OpenAI API** (Chat Completions + Image Generation)

---

## Architecture Overview (MVVM)
- **Views**: SwiftUI tab-based UI (Home, Ingredients, Recipes, Favorites)
- **ViewModels**:
  - `RecipeViewModel` — manages generating and displaying recipes
  - `FavoritesViewModel` — handles saving/removing favorites
- **Services**:
  - `OpenAIService` — handles all OpenAI API calls
