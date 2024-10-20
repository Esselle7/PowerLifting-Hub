# PowerLifting Hub - Frontend (Flutter)

This repository contains the **Flutter** frontend for **PowerLifting Hub**, a cross-platform social application built for powerlifters, street lifters, and coaches. The application allows users to track their personal records, connect with coaches, join communities (crew), and participate in a gamified competitive experience.

## Project Overview

**PowerLifting Hub** is a platform designed for athletes to log, track, and share their training progress, specifically targeting the powerlifting and street lifting communities. The app facilitates interaction between athletes and coaches, and in future versions, will support sponsors. The backend of the project is built with **Java Spring Boot** and is hosted in a separate repository, while **MySQL** is used for the database.

### Main Features
- **User Registration & Profiles**: Supports registration for three main types of users:
  - **Athletes**: Create personal profiles, log personal bests in powerlifting and streetlifting.
  - **Coaches**: Manage athlete profiles, display certifications, and highlight results achieved by their athletes.
  - **Sponsors** (Future Release): Ability to create profiles, organize teams, and connect with top athletes.
  
- **Max Lifts Tracking**: Athletes can input their personal records (PRs) for major powerlifting exercises (squat, bench, deadlift) and streetlifting exercises.
  
- **Athlete Categorization**: Users can be categorized into:
  - **Powerlifters**
  - **Street Lifters**
  - **General Users**: Track personal bests across all disciplines and compete with friends.

- **Athlete-Coach Connection**: Athletes can connect with coaches for personalized training plans and progress tracking.

- **Crew System**: Athletes can create and join crews, which may be linked to sponsors or teams. Crews have dedicated channels for communication and can be organized around specific sponsors or goals.

- **Competition & Gamification**: Athletes can log their competition results from official events and earn recognition. Future plans include implementing a ranking system and leaderboards.

- **Direct Messaging (DM) and Social Features**: Athletes, coaches, and crews can communicate via an integrated messaging system, with potential integrations to external social media platforms.

- **Event & Competition Integration**: Integration with calendars to keep track of upcoming competitions and events. The app aims to retrieve official competition results automatically (future phase).

- **Social Logins**: Support for logging in via Google and Facebook accounts.

### Tech Stack
#### Frontend:
- **Flutter**: Cross-platform framework using **Dart** for building a unified UI for iOS and Android devices.
- **State Management**: Utilizing **Provider** or **Riverpod** (depending on the phase of development) for efficient state management across the app.
- **UI/UX Design**: Material Design and Cupertino widgets to ensure native feel across platforms.

#### Backend (separate repository):
- **Java Spring Boot**: Handles business logic, user authentication, and manages API endpoints for communication with the frontend.
- **MySQL**: Database to store user data, PRs, competition results, and connections between athletes and coaches.

### Critical Considerations

#### Manual Data Entry for Athletes
Unlike platforms like Strava, which automatically track progress, **PowerLifting Hub** relies on manual input from athletes to track their PRs and competition results. This gives athletes full control but may require more effort to maintain accurate records.

#### Competitions and Result Tracking
In the future, we aim to integrate with external competition result systems to automatically update athlete profiles after events. Current challenges include the lack of public APIs for official powerlifting federations (e.g., FIPE, FIPL). A potential solution could be to scrape data from competition results (e.g., PDF parsing), but this may be implemented later.

#### Sponsorship and Crew Management
The platform will eventually support sponsor profiles, allowing sponsors to create teams of athletes and track their sponsored athletes’ achievements. This feature is complex due to the need to interface with companies rather than individual users, and may be postponed to a future release.

#### Scalability
The project is designed with future scalability in mind. By adopting a **microservices architecture** for the backend, new features can be introduced seamlessly without causing major disruptions. This allows us to scale not just in terms of features but also in terms of infrastructure, supporting potential growth in the user base and functionalities.

### Future Features
- **Advanced Gamification**: Expand gamified elements such as leaderboards, badges, and challenges.
- **Sponsor System**: Include sponsors who can track the performance of athletes they support.
- **Automatic Data Retrieval**: Automate the process of retrieving competition results and PR updates via external APIs or data scraping.
- **Wave2 Card Management**: Implement a system for coaches to manage and assign workout programs to their athletes.
  
## Getting Started

### Prerequisites
- Flutter SDK: https://flutter.dev/docs/get-started/install
- Dart: Included with Flutter SDK
- Android Studio or Xcode (for mobile development)
- A backend running the Java Spring Boot system (check the backend repository for more details)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/powerlifting-hub-flutter.git
   cd powerlifting-hub-flutter
2. **Instal dependencies:**
   ```bash
   flutter pub get
3. **Run the app::**
    ```bash
    flutter run

### API Integration
The app communicates with the backend via REST APIs. Ensure that the backend (Spring Boot) is running and accessible. Modify the API base URL in the Flutter app’s configuration to point to your backend server.

### License
This project is licensed under the MIT License - see the LICENSE file for details.

This README outlines the purpose and structure of the project, providing a clear overview of the features, technology stack, and development instructions for contributors. The project is designed for scalability, with plans for future expansions, especially regarding the integration of sponsors and automated data retrieval.
