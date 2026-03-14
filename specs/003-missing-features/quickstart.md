# Getting Started: Implementing Feature 003

## Dependencies 
Update the active `pubspec.yaml` to include tools for the user sharing flow.
```yaml
dependencies:
  share_plus: ^10.1.4
```

## Running the App

After modifications, use the established test scripts.
```bash
flutter test
flutter run
```

Ensure no new memory leaks are visible when repeatedly opening native share dialogs or scrolling `NotesScreen`.
