# User Hub

This is a Flutter project made for a Flutter development assignment.

In this project, I have implemented Firebase Authentication, API integration, pagination, pull to
refresh and MVVM architecture.

## Features

* Login using Email and Password
* Signup using Email and Password
* Logout
* User list from API
* Show user profile image, name and email
* Pagination
* Load 5 users per page
* Load next page when scrolling
* Pull to refresh
* Loading indicator
* Error handling

## Technologies Used

* Flutter
* Dart
* Provider
* Dio
* Firebase Authentication
* Cached Network Image
* ReqRes API

## Architecture

I have used **MVVM architecture** in this project.

```text
Screen
   ↓
ViewModel
   ↓
Repository
   ↓
ApiService
   ↓
API
```

Provider is used for state management.

## API

I have used ReqRes API for getting users.

API:

```text
https://reqres.in/api/users
```

Method:

```text
GET
```

Query Parameters:

```text
page=1
per_page=5
```

5 users are loaded on each page.

## Pagination

When the user scrolls to the bottom of the list, the next page is called automatically.

For example:

```text
Page 1 → 5 users
Page 2 → 5 users
Page 3 → 5 users
```

The new users are added to the existing list.

## Pull to Refresh

The user can swipe down on the user list to refresh the data.

It starts again from page 1 and gets the latest user list.

## Project Structure

```text
lib/
├── models/
├── services/
├── repositories/
├── viewmodels/
├── screens/
├── widgets/
└── main.dart
```

## Firebase

Firebase Authentication is used for:

* Signup
* Login
* Logout

Email and Password authentication is used.

## How to Run

First get the packages:

```bash
flutter pub get
```

Then run the project:

```bash
flutter run
```

Firebase should be configured before running the authentication features.

## APK

To create APK:

```bash
flutter build apk --release
```

## Developer

Kundan Kumar Singh

Flutter Developer
