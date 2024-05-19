# trainit

A Cross-Platform-Application to manage your trainingplans and statistics based on Flutter and Dart

## Structure

### Pattern

The app uses the BLoC-pattern

Presentation layer: The UI in form of Widgets

- Gives Events to BLoC's
- Accesses BloC's states for data

BLoC layer: Contains Business-Logic and connects the Data layer and Presentation layer in form of BLoC's

- Fetches data from repositories
- gives repositories new/updated data
- provides widgets state
- listens to widgets for data-update

Data layer: Contains Code to manage data sources as remote or local databases in form of repositories

- provides BLoC's data from data-sources
- forwards BLoC's updated data to data-sources

The main.dart file can access the data layer directly to load data on startup (for example the selected Theme)

![Layers](https://www.flutterclutter.dev/images/wp-content/uploads/2021/02/flutter-bloc-communication-diagram.webp)

Source: <https://www.flutterclutter.dev/flutter/basics/what-is-the-bloc-pattern/2021/2084/>

### Dictionary-structure

the top main.dart is the start point -> initializing navigation between features, initializing blocs, initializing repositories, initializing Firebase
main-screens handle Navigation for the feature and access the Blocs (filename: "main.dart")

- presentation
  - feature 1
    - widgets
      - widget 1 for feature 1
      - widget 2 for feature 1
      - widget ...
    - screen 1 for feature 1
    - screen 2 for feature 1
    - screen ...
    - main screen for feature 1
  - feature 2
    - widgets
      - widget 1 for feature 2
      - widget 2 for feature 2
      - widget ...
    - screen 1 for feature 2
    - screen 2 for feature 2
      - screen ...
    - main screen for feature 2
  - feature ...
    - ...
- data
  - model 1
  - model 2
  - ...
- bloc
  - feature 1
    - bloc, events, states for feature 1
  - feature 2
    - bloc, events, states for feature 2
  - feature ...
    - ...
main.dart -> main entry point
app.dart -> flutter app entry point

## Data Sources

Firebase:

- using performance-, analytics- and crashlytics services to analyze application
- using authentication service to authenticate users in a secure way

Backend:

- main database with userspecific data (statistics, trainingplans, ...)
- access is authenticated -> connected to Firebase

Local Storage:

- synched with userdata in remote-backend
- saving userdata for offline-use

## Networking

- networking can be handled by using the "Remote" class
- you can use the function .execute to execute a request
- possible are normal requests (class NetworkRequest) and Multipart Requests (class MultipartNetworkRequest)
- objects provided to the body property will be automatically casted into json
- undone network requests can be cached and will be checked on the next reload

## Commands

Run Object-Box Build: flutter pub run build_runner build

## Workflows

### Data-Synching

- DataCubit synchs local data with remote data
- DataCubit fires EventBus
- Blocs listen to EventBus and update on event

### Logging

- Class Loggers contain multiple Loggers
- firebaseLogger for Firebase Logging
- appLogger for Logging of App Behaviour

## Resources

Illustrations: <https://undraw.co/>
