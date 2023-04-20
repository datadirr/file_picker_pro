[<img src="https://datadirr.com/datadirr.png" width="200" />](https://datadirr.com)

# file_picker_pro

Flutter plugin for selecting files from any devices file library, and taking a new pictures with the camera.

## Using

For help getting started with Flutter, view our
[online documentation](https://pub.dev/documentation/file_picker_pro/latest), which offers tutorials,
samples, guidance on mobile and web development, and a full API reference.

## Installation

First, add `file_picker_pro` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

In your flutter project add the dependency:

```yml
dependencies:
  ...
  file_picker_pro:
```

For help getting started with Flutter, view the online
[documentation](https://flutter.io/).

## Setup Configuration

- Please check if use cameraPicker {support Android, iOS, Web} [image_picker](https://pub.dev/packages/image_picker) with image crop functionality [image_cropper](https://pub.dev/packages/image_cropper).
- Please check if use imagePicker {support Android, iOS, Web} [image_picker](https://pub.dev/packages/image_picker) with image crop functionality [image_cropper](https://pub.dev/packages/image_cropper).
- Please check if use filePicker [file_picker](https://pub.dev/packages/file_picker).
- Please check if use viewFile [open_filex](https://pub.dev/packages/open_filex) or [open_share_plus](https://pub.dev/packages/open_share_plus).


### Android

The Android implementation support to pick (multiple) images on Android 4.3 or higher.

- If use image crop functionality, Add UCropActivity into your AndroidManifest.xml
  More info please check [image_cropper](https://pub.dev/packages/image_cropper).
````xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
````
**Note:** From v1.2.0, you need to migrate your android project to v2 embedding ([detail](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects))

No configuration required - the plugin should work out of the box. It is
however highly recommended to prepare for Android killing the application when
low on memory. How to prepare for this is discussed in the [Handling
MainActivity destruction on Android](https://pub.dev/packages/image_picker)
section to `image_picker` library.
More info please check [image_picker](https://pub.dev/packages/image_picker).

It is no longer required to add `android:requestLegacyExternalStorage="true"` as an attribute to the `<application>` tag in AndroidManifest.xml, as `file_picker_plus` has been updated to make use of scoped storage.


### iOS

This plugin requires iOS 9.0 or higher.

The iOS implementation uses PHPicker to pick (multiple) images on iOS 14 or higher.
As a result of implementing PHPicker it becomes impossible to pick HEIC images on the iOS simulator in iOS 14+. This is a known issue. Please test this on a real device, or test with non-HEIC images until Apple solves this issue. [63426347 - Apple known issue](https://www.google.com/search?q=63426347+apple&sxsrf=ALeKk01YnTMid5S0PYvhL8GbgXJ40ZS[…]t=gws-wiz&ved=0ahUKEwjKh8XH_5HwAhWL_rsIHUmHDN8Q4dUDCA8&uact=5)

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.


### Web
- If use image crop functionality, Add following codes inside `<head>` tag in file `web/index.html`
  More info please check [image_cropper](https://pub.dev/packages/image_cropper).

```html
<head>
  ....

  <!-- Croppie -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.css" />
  <script defer src="https://cdnjs.cloudflare.com/ajax/libs/exif-js/2.3.0/exif.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js"></script>

  ....
</head>
```


**Note:** file picked using the camera, gallery or file are saved to your application's local cache, and should therefore be expected to only be around temporarily.
If you require your picked image to be stored permanently, it is your responsibility to move it to a more permanent location.


## Example

Please follow this [example](https://github.com/datadirr/file_picker_pro/tree/master/example) here.


### File Picker with default UI

```dart
FilePicker(
  context: context,
  height: 100,
  fileData: _fileData,
  crop: true,
  maxFileSizeInMb: 10,
  allowedExtensions: Files.allowedAllExtensions,
  onSelected: (fileData) {
    _fileData = fileData;
  },
  onCancel: (message, messageCode) {
    log("[$messageCode] $message");
  }
)
```

### Camera Picker

```dart
Files.cameraPicker(
  fileData: _fileData,
  onSelected: (fileData) {
    _fileData = fileData;
  }
);
```

### Image Picker

```dart
Files.imagePicker(
  fileData: _fileData,
  onSelected: (fileData) {
    _fileData = fileData;
  }
);
```

### File Picker

```dart
Files.filePicker(
  fileData: _fileData,
  onSelected: (fileData) {
    _fileData = fileData;
  }
);
```