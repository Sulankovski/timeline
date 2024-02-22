# Timeline

## Description
Our social platform empowers users to create diverse events, offering the ability to specify event visibility for individual groups. Users can effortlessly organize events based on date, time, location, and group preferences. Events are displayed both on a map and a calendar interface, providing intuitive navigation. Additionally, all public events are universally accessible to every user.

## Features
The application seamlessly integrates Firebase sign-up/log-in functionality for user authentication, alongside robust features such as a map screen, a calendar screen showcasing events organized by days, a public events screen, and a profile screen presenting user information. Additionally, the app offers live and real-time updates of data, ensuring that users have access to live data.

## Map Screen
The Maps screen utilizes a map API key to display the map, showcasing all events created by the user. Each marker on the map is clickable, providing detailed information for every event when selected.

The events are fetched from Firebase upon initialization of the page and are stored in a map where the keys are LatLng objects (representing the event's location) and the values are instances of a custom Event class.

Upon page creation, the values for each key (LatLng) are retrieved, and a marker is created for each data row, representing an event on the map. This approach allows users to easily visualize and interact with their events directly on the map interface.

## Calendar Screen
The Calendar screen features a horizontally displayed calendar. Below the calendar, events scheduled for the selected day are showcased. These events are fetched from Firebase upon initialization of the screen and stored in a map with String keys and Dynamic values.

For every new day that is selected, the events are retrieved from the map and displayed using a ListView builder. Each row within the ListView displays the event's name and date, followed by the time and type of event. Upon clicking an event, users are prompted with detailed information including the event's name, creator, and participants.

The home screen also offers the functionality to add a new event by clicking the plus icon located at the bottom right corner. Users begin by choosing a picture for the event they want to create. Then, they input the name of the event, select the date and time, choose a location from a location prompt, and specify the type of event (public, private, group).

Upon submission, the event is immediately displayed thanks to live updates fetched from Firebase. This ensures that users can see their newly added events in real-time without any delay.

## Public Events Screen
The Public Events screen displays all the public events created by users. It utilizes a StreamBuilder for fetching events, enabling real-time updates. This means that if a different user adds a public event, it will immediately appear on our screen, even if we are already using the app.

The events are presented using a ListView builder, where each row showcases the event's name, date, and time. Moreover, users can express their interest in participating by liking events, and this interaction is instantly reflected for all users in real-time. This functionality is facilitated by a function that retrieves the likes for each event whenever the like icon is clicked.

Furthermore, the screen features a group icon. Upon clicking it, detailed information for every event is displayed, allowing users to gain more insight into each event.

## Profile Screen

The Profile Screen displays the username of the user along with the number of public, private, and group events associated with their account. Additionally, there is a sign-out button that allows users to end their session, logging them out and redirecting them to the login screen. This feature ensures a seamless transition for users between sessions while maintaining security and privacy.

## Log In / Sign Up Screen
Login Screen that utilizes Firebase Authentication to enable users to log in using the Gmail address and password associated with their account. This secure login process ensures that users can access their accounts with ease, utilizing the credentials they initially created their account with.

The Sign-Up Screen enables users to create a new account using FirebaseAuth methods, where they input their username, email, and password. Upon successful account creation, users are seamlessly redirected to the main page, ready to explore the app's features.
Upon every new sign-up, a new user is created with designated Firestore and Storage resources. This ensures that each user has their own dedicated storage and database space, allowing for personalized data management and efficient access to resources within the app.

## App structure and code

The app's codebase is organized into distinct files to ensure clarity and maintainability:

Screens: Each screen, such as login and sign-up, has its own file to manage UI components effectively.
Resources: Firebase-related methods, including user authentication and event management, are centralized in firebase_methods.dart.
Widgets: Reusable UI components are stored in the widgets directory to reduce redundancy and streamline development.
Utils: Utility methods, like image selection, are housed in utils for convenient access and code cleanliness.
Global Variables: Essential variables, such as navigation configurations and color palettes, are defined in global_variables.dart.
Main: The main.dart file serves as the app's entry point, managing initialization and user session persistence.


