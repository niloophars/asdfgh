# NOM NOM
NOM NOM is a mobile application that simplifies home cooking by providing recipes suggestions based on user search and categorical filters.

## Features
* **User Authentication:** Users can securely create an account using their name, email, and password. Using Firebase Integration, it handles authentication and stores user credentials.
* **Home Screen:** It displays all recipes categorized by meal type: Breakfast, Lunch, Dinner, Dessert, Drinks. It shows featured recipes or recently added dishes.
* **Recipe Search:** Allows the user to search by first letter, for example: to search Mango Smoothie we just have to type M or S. It allows category-based filtering to browse recipes based on categories like breakfast, dessert, lunch, drinks etc. Quick search experience for discovering dishes without typing long queries.
* **Add Recipe:** Users can submit their own recipes by providing ingredients, recipe name, category, images. It saves user-contributed content to the Firebase database.
* **Favourites / Wishlist:** It allows users to bookmark recipes they love. Recipes are accessible from the favourites tab for quick reference.
* **Ratings System:** Enables the users to rate recipes they’ve tried.
* **Firestore Database:** Stores recipes, user info, ratings, and favourites. It includes features like login, recipe categories, search, favourites, and ratings. Users can add recipes and view detailed profiles.

## Architecture
<img width="857" height="524" alt="Software Architecture Diagram of NOM NOM" src="https://github.com/user-attachments/assets/8ec8fd6a-d7f7-4adf-8def-8f5bfd2d688e" />

## Modular Organization
<img width="868" height="271" alt="Modular diagram of NOM NOM" src="https://github.com/user-attachments/assets/c61e7ac0-67a2-49b0-876f-4c7ce3bd45dc" /> 

## Flow Diagram
<img width="1007" height="681" alt="Flow Diagram of NOM NOM" src="https://github.com/user-attachments/assets/ea9650ec-fadc-480a-90b6-353fab87c487" />



## Screens
| Onboarding Screen    | Signup Page   | Login Page    | Profile Screen   | Home Screen |
| ---------------------| ------------- | --------------| -----------------| ------------|
<img width="189" height="309" alt="Onboarding Screen" src="https://github.com/user-attachments/assets/dddf4d65-bdc2-4d52-af21-663da7019240" /> | <img width="202" height="331" alt="Signup Page" src="https://github.com/user-attachments/assets/db67f853-4fd1-40a1-a6ea-405c6c405e0f" /> | <img width="177" height="327" alt="Login Page" src="https://github.com/user-attachments/assets/6ec0c74f-25aa-445d-b80e-45c253b44c0e" /> | <img width="203" height="412" alt="Profile Screen" src="https://github.com/user-attachments/assets/76bcfc20-f474-43cc-9469-7ea39aa0a737" /> | <img width="240" height="458" alt="HomeScreen" src="https://github.com/user-attachments/assets/9291000e-0100-436b-acc6-31a96ca7a6e4" />


| Recipe Details Screen | Favourites Screen | Ratings Screen |  Category Search Screen |
| --------------------- | ------------------| ---------------| ------------------------|
<img width="415" height="384" alt="Recipe Details Screen" src="https://github.com/user-attachments/assets/22a0408c-506b-4fc7-8357-f194944ccb0c" /> | <img width="230" height="341" alt="Favourites Screen" src="https://github.com/user-attachments/assets/c764e847-6ce0-4af4-846a-577e0c777692" /> | <img width="248" height="401" alt="Ratings Screen" src="https://github.com/user-attachments/assets/a23902b8-9316-4624-9e7a-3da76e7052e6" /> | <img width="230" height="435" alt="Category Search Screen" src="https://github.com/user-attachments/assets/9ac2383d-4f1f-43d5-bc51-95aef6e19d48" />


| Add Recipe Screen |
| ------------------|
<img width="883" height="362" alt="Add Recipe Screen" src="https://github.com/user-attachments/assets/9ba70c74-d909-4a80-b0bb-82585c078701" /> |

## Future Enhancements
1. **AI-Powered Personalization:** Introduce machine learning to analyze user preferences and make smarter, more personalized suggestions over time.
2. **Expanded Recipe Library:** Collaborate with chefs, food bloggers, or use APIs to enrich the recipe database with global cuisines and dietary options.
3. **Meal Planning Tools:** Add features like weekly planners, automatic grocery lists, and calendar syncing.
4. **Voice Interaction:** Integrate voice assistants for hands-free recipe suggestions and step-by-step cooking guidance.
5. **Offline Functionality:** Allow users to save recipes or cache data for access without an internet connection.
6. **Social Features:** Let users share recipes, and follow friends or cooking influencers within the app.

## Resources

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


