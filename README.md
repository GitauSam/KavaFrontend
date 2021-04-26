# Kava Journal Front End

This application consumes the apis exposed by Kava Backend (https://github.com/GitauSam/KavaBackend).

## How To Run

#### Prerequisites
ngrok
flutter environment setup (Get proper details here: https://flutter.dev/docs/get-started/install)

### Steps
1. First run the backend application.
2. Create a tunnel using ngrok to localhost port 8000 './ngrok http 8000'.
3. Copy the secure tunnel link provided by ngrok.
4. Paste the link to the static url variable in the AppConstants class found in app_constants.dart file e.g static String url = "https://0b37d59a716e.ngrok.io".
5. Then run the application.
