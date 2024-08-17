Error handling is essential to creating mobile apps since it makes sure that
even in the face of unforeseen problems, your Flutter app will run smoothly
and be user-friendly.
So this package is focused on Error handling with type-safety,clean architecture,and solid principles

## Features
- futureAsync()
- registerErrorHandler()

## How To Use
First of all you should initialize the Handler in main app
```dart
WidgetsFlutterBinding.ensureInitialized();
ErrorHandler.init();
ErrorHandler.registerErrorHandler();
```

Then you can use handler
```dart
final response = await ErrorHandler.futureAsync((){
  return 2023;
});
print(response.data);
```

You can return nothing and have null data

## Author
This Error handler is developed by Hassan-Ghasemzadeh.

## Contact
Email: software.clean.development@gmail.com