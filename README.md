#  Discovering Movies

## About 
This app uses the TMDB apis to fetch & browse movies and save them locally as favorites. 

## Design
The app has 3 distinct layers the `View specification` called as `View` the `Store` and `Service`. 
The Service layer interacts with external dependencies and services like file services. 

![SystemDesign](https://user-images.githubusercontent.com/96450350/204686436-132c92e1-ea00-47fb-9211-eb9436f73a2b.png)


## External Dependencies
To fetch the movies from TMDB this app uses https://github.com/adamayoung/TMDb integrated via swift package manager.

## Improvements
- Show an offline bar
- Add a refresh/reset option when the app is offline mode to reinitialize the app.
- Offline mode - save a new favorite for the already loaded movies.
- The favorites need to be refreshed periodically on app initialization such that the data is always up to date. 
- Favorite button could use an error state. 
- Tests - the stores can be tested.
- UI Tests - on adding some accessibility identifiers.
- Add a launch screen

## Shots


### Open the app without any network
![NoNetwork](https://user-images.githubusercontent.com/96450350/204687928-eb7ed254-d801-4241-b648-de332ee1e7d7.gif)


### Browse app, save & delete favorites
![SaveFavorite_Com](https://user-images.githubusercontent.com/96450350/204688200-c74c3175-3890-424c-930f-4b2a11bbd382.gif)

### Access Saved Favorites when in Offline mode
![AccessFavoriteFromOffline](https://user-images.githubusercontent.com/96450350/204688339-ade6a13d-1a67-4046-b724-432278335f48.gif)
