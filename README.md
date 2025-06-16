# facebook_results

A result-management Flutter app that enables users to manage members, scores, and score history using Google Sheets as a backend.

https://github.com/user-attachments/assets/203a03f4-1654-4c40-9dfd-d75fd5be284e


# Building and Running the Flutter Application

## Prerequisites:
Before you begin, ensure you have the following installed:
- **Flutter SDK:** Follow the official Flutter installation instructions for your operating system.
- **Dart SDK:** Flutter requires the Dart SDK. It's included with the Flutter SDK, so you don't need to install it separately.
- **Android Studio/VS code or Xcode:** Depending on whether you're targeting Android or iOS, you'll need either Android Studio/VS code or Xcode installed.
## Getting Started:
1. Clone the repository:
	```
	git clone https://github.com/shivangsorout/facebook_results
	```
2. Navigate to the project directory:
	```
	cd <project_directory>
	```
3. Install dependencies:
	```
	flutter pub get
	```
## Running the Application:
- **Android**   
Ensure you have an Android device connected via USB or an Android emulator running.   

- Run the command in terminal:
 ```
 flutter run
 ```
- **iOS**   
Ensure you have a macOS machine with Xcode installed.   

- Run the command in terminal:
 ```
 flutter run
 ```
# Application Features
- **Member Management:** Allows users to add, update, and delete member profiles with attributes such as name, admin status, and unique IDs.
- **Score Management:** Enables adding and updating scores for each member as well as the admins.
- **Sheet Integration:** Uses Google Sheets as a dynamic backend for storing and retrieving data, ensuring data persistence and accessibility.
- **History Tracking:** Supports managing and retrieving score history by associating entries with specific sheets named by timestamp, allowing easy comparison over time.
- **Dynamic Sheet Creation:** Automatically generates new Google Sheets with timestamped names to track different score sessions.
- **Flutter Frontend:** Built with a responsive Flutter interface for smooth cross-platform experience on mobile and web.
- **Google Apps Script Backend:** Uses secure and structured Google Apps Script web functions (doGet, doPost) to handle all CRUD operations and ensure seamless communication between the frontend and Google Sheets backend.
- **Error Handling & Logging:** Includes structured error responses and Google Apps Script logs for debugging and monitoring.
