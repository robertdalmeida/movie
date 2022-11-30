#  Discovering Movies

## About 
This app uses the TMDB apis to fetch movies and save them locally as favorites. 

## Design


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
