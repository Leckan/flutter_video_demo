# flutter_video_demo

# Flutter Video Upload App

## Setup Instructions
1. Install Flutter (version 3.x.x)
2. Configure Firebase:
   - Add google-services.json (Android) and GoogleService-Info.plist (iOS)
   - Enable Firebase Authentication with Google, Facebook, and Email providers
3. Configure GCS:
   - Add service account JSON credentials
   - Ensure bucket permissions for `flutter-challenge-uploads`
4. Run `flutter pub get`
5. Run `flutter run`

## Implementation Notes
### Authentication
- Supports Google, Facebook, and Email/Password auth
- Uses Firebase Authentication
- Maintains session via AppState

### Upload Process
- Videos uploaded to GCS bucket: `flutter-challenge-uploads`
- Path format: `uploads/{userId}/{timestamp}-{filename}`
- Progress tracking (mocked due to limitations)
- Cancel upload not implemented due to time constraints

### Notifications
- Uses Firebase Cloud Messaging
- Local notifications for upload completion
- Mock backend service simulates notification sending

### Known Limitations
- Video preview not implemented
- Upload progress is mocked
- Limited error handling
- Basic UI without extensive styling

## Testing
1. Test authentication:
   - Google: Verify account picker and login
   - Facebook: Verify FB login flow
   - Email: Test both register and login
2. Test video upload:
   - Pick from gallery/camera
   - Verify GCS upload
   - Check upload history
3. Test notifications:
   - Verify permission request
   - Confirm notification on upload completion
