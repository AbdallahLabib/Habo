[![Screens](https://habo.space/img/social/1.png)](https://habo.space)

![Codemagic build status](https://api.codemagic.io/apps/6154a5e032cdf915d1ce822b/6154a5e032cdf915d1ce822a/status_badge.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Translation status](https://hosted.weblate.org/widget/habo/habo/svg-badge.svg)](https://hosted.weblate.org/engage/habo/)
![GitHub release (with filter)](https://img.shields.io/github/v/release/xpavle00/Habo)
![GitHub Repo stars](https://img.shields.io/github/stars/xpavle00/Habo)



# Habo - Open-Source Habit Tracking App

Introducing Habo, the open-source habit tracker app that helps you create and maintain healthy habits for a better life. With its user-friendly interface, Habo makes it easy to track your daily routines and monitor your progress.

With Habo, you can customize your own habit list, set reminders, and add notes to help you stay motivated. Whether you're looking to improve your exercise routine, eat healthier, or simply adopt better habits, Habo is here to help you succeed. 

It is built using the [Flutter](https://flutter.dev/) framework, a popular and powerful cross-platform development tool.

## Features

- Customize your habit list
- Set daily reminders
- Track your progress with insightful statistics
- Add notes to help keep you motivated
- And more!

Currently available on the Play Store and App Store.

[![Google play store](https://habo.space/img/resources/en_get.svg)](https://play.google.com/store/apps/details?id=com.pavlenko.Habo) <a target="_blank" href="https://apps.apple.com/us/app/habo-habit-tracker/id1670223360?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 134px; height: 40px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1682121600" alt="Download on the App Store" style="border-radius: 13px; width: 134px; height: 40px;"></a>

# My Contribution Documentation on this project

## Introduction

The app was forked and updated with significant changes including restructuring the app with a Feature-First style and clean architecture, and the addition of Firebase Firestore for cloud data storage.

## Application Structure

The application is divided into two main folders:

1. **Core**: Contains all the services, helpers, and utils of the app.
2. **Features**: Contains all the app's features.

Each feature inside the Features folder is divided into four layers:

1. **Data Layer**: Contains the Remote and Local data sources, the Models folder, and the Repository folder. The Remote uses Firebase and the Local uses SQLite.
2. **Domain Layer**: Contains the business logic of the app, including the Repository folder which works as an interface for the Data Layer, the Entity Folder which contains all the entities related to the current feature, and the use cases folder which contains all the use cases.
3. **Application Layer**: Contains the Controller where state management goes.
4. **Presentation Layer**: Contains the UI of the app, divided into Screens and Widgets.

## Firebase Firestore Data Handling and Storage

Firebase Firestore has been integrated for cloud data storage, designed for a single user scenario at this stage. The user can add a new habit and modify the state of a habit in Firestore. 

- **Data Partitioning:** The data has been partitioned across multiple collections ("users", "habits", and "habit_status") with each collection serving a different purpose and storing a specific type of data.
- **Scalability with User Growth:** The Firestore DB design allows for easy addition of new users and their habits. Each user has a unique user_id and other habit data. The user_id field in the "habit" collection creates a link to the "users" collection,This allows the database to grow horizontally as new users join.
- **Scalability with Habit Growth:** The "habit_status" collection can grow as new habits are added or existing habits change their status. The habit_id field in the "habit_status" collection creates a link to the "habits" collection, allowing for scalability as the number of habits or their statuses increase.

The "users" collection contains the following fields:
- user_name (String)
- avatar (String)
- In the future we can add more fields

The "habits" collection contains the following fields:
- user_id (String): A unique identifier for the user to link this collection to the "users" collection
- All "habit" attributes that are saved locally, e.g: title, cue, routine, sanction, showReward, showSanction, notification, noTime ...

The "habit_status" collection contains the following fields:
- habit_id (String): A unique identifier for the habit to link this collection to the "habits" collection
- status (String): The status of the habit (Check, Failed, Paused)
- day (int): The day the habit status was updated
- date (int): The date and time the habit status was updated
- comment (String): Any comments or notes about the habit

## Choosing Between Future and Stream

A choice was made between Future and Stream for Firestore implementation. A Future represents a single asynchronous operation that produces a single value and completes, suitable for one-time requests. A Stream provides a sequence of results, akin to a Future that fires multiple times, suitable for continuous data sources like listening for real-time updates to a database in Firebase.

## Future Updates

Authentication and server connection, currently absent, are planned for future updates. An authentication cycle with phone, username, password, and social authentication with Google and Facebook is planned. The app will also shift from Provider to Riverpod for state management in future updates.

**IMPORTANT NOTE:** 
- The original version of the app was designed to work offline, catering to individual users without requiring any form of authentication. All data was stored locally on the user's device.
- An enhancement was introduced to the app with the integration of Firebase Firestore. This allowed for data to be saved in the cloud, expanding the app's data storage capabilities.
- Despite this integration, the local data storage implementation is still maintained. This is due to the significant time investment required to undertake a full migration of all data to the cloud.
- Furthermore, a change in the state management solution, from Provider to Riverpod, is also planned for future updates. However, this change also requires a substantial amount of time to implement.
- In light of these considerations, the app continues to operate with both local and cloud data storage capabilities for the time being.

# Refactoring Plan

The plan for refactoring the application involves the following steps:

1. **Decoupling the Business Logic from the UI in "Habit" Widget:** The business logic in the "Habit" widget, which displays all the details of a habit, needs to be decoupled from the UI. This will make the code cleaner and easier to maintain.

2. **Refactoring "HabitManager":** The "HabitManager" should be sent to the data layer, and an abstract layer should be created on top of it to handle its communication with the Domain layer. Although "HabitManager" has already been sent to the Data layer, creating the abstraction layer and handling the communication with the Domain layer would require significant refactoring time and effort.

3. **State Management:** The state management solution should be switched from Provider to Riverpod. Riverpod not only handles states but also manages Dependency Injection, which enhances the separation of concerns. This change will give Riverpod full control over the UI rebuilds.

4. **Unit Testing:** Unit tests should be written for the application layer and the usecases inside the Domain layer. This will help ensure the integrity of the application and catch any potential issues early in the development process.

The above steps represent a significant overhaul of the application's architecture and will require a considerable amount of time to implement. However, they will result in a more scalable, maintainable, and testable application.


