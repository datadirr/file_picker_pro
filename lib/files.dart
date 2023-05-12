import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_pro/file_data.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_share_plus/open.dart';

/// file mode of open file picker
enum FileMode {
  /// pick from camera
  camera,

  /// pick from gallery
  gallery,

  /// pick from file
  file
}

/// [Files] provide verity of file picker like camera, gallery, file
/// pre-define ui for file picker
/// use customize ui and file pick
class Files {
  Files._();

  static const String cropperToolbarTitle = "Crop";
  static const Color cropperToolbarColor = Colors.black;
  static const Color cropperToolbarWidgetsColor = Colors.white;
  static const String _filePickCancel = "File picker cancel";
  static const String _fileNotFound = "File not found";
  static const String _fileCouldNotLoad = "File could not load";

  static String _fileMoreThanMB(int maxFileSizeInMb) =>
      "File more than $maxFileSizeInMb MB, Please select another file";
  static const int _mcFPCForCancel = 1;
  static const int _mcFPCForSize = 2;

  /// file extensions
  static const pdf = "pdf";
  static const doc = "doc";
  static const docx = "docx";
  static const xls = "xls";
  static const xlsx = "xlsx";
  static const ppt = "ppt";
  static const pptx = "pptx";
  static const jpg = "jpg";
  static const jpeg = "jpeg";
  static const png = "png";
  static const gif = "gif";

  /// allowed all extensions
  static const List<String> allowedAllExtensions = [
    Files.pdf,
    Files.doc,
    Files.docx,
    Files.xls,
    Files.xlsx,
    Files.ppt,
    Files.pptx,
    Files.png,
    Files.jpg,
    Files.jpeg
  ];

  static bool _isNullOREmpty(String? str) {
    if (str == null || str.isEmpty) {
      return true;
    }
    return false;
  }

  /// check http file path
  static bool isHttpPath(String filePath) {
    if ((filePath.toLowerCase()).startsWith('http')) {
      return true;
    } else {
      return false;
    }
  }

  /// get file name from file path or url
  static String getFileName(String? path, {bool withExtension = true}) {
    String fileName = "";
    if (withExtension) {
      if (!Files._isNullOREmpty(path)) {
        if (path.toString().contains("/")) {
          fileName =
              (path.toString().substring(path.toString().lastIndexOf("/")))
                  .replaceAll("/", "");
        } else {
          fileName = path.toString();
        }
      }
    } else {
      if (!Files._isNullOREmpty(path)) {
        if (path.toString().contains("/")) {
          fileName =
              ((path.toString().substring(path.toString().lastIndexOf("/")))
                      .replaceAll("/", ""))
                  .replaceAll(Files.getFileExtension(path), "");
        } else {
          fileName =
              (path.toString()).replaceAll(Files.getFileExtension(path), "");
        }
      }
    }
    return fileName;
  }

  /// get file extension
  static String getFileExtension(String? path, {bool withDot = true}) {
    String extension = "";
    if (withDot) {
      if (!Files._isNullOREmpty(path)) {
        if (path.toString().contains(".")) {
          extension =
              path.toString().substring(path.toString().lastIndexOf("."));
        } else {
          extension = ".${path.toString()}";
        }
      }
    } else {
      if (!Files._isNullOREmpty(path)) {
        if (path.toString().contains(".")) {
          extension =
              (path.toString().substring(path.toString().lastIndexOf(".")))
                  .replaceAll(".", "");
        } else {
          extension = path.toString();
        }
      }
    }
    return extension;
  }

  /// get file mime type
  static String getMimeType(String? path) {
    String? mimeType = lookupMimeType(path!);
    if (Files._isNullOREmpty(mimeType)) {
      mimeType = "";
    }
    return mimeType.toString();
  }

  /// get file size in KB
  static double kb(int sizeInBytes) {
    return sizeInBytes / 1024;
  }

  /// get file size in MB
  static double mb(int sizeInBytes) {
    return Files.kb(sizeInBytes) / 1024;
  }

  /// selected file path or url to set FileData
  static FileData setFileDataFromUpdate({required String? path}) {
    FileData fileData = FileData();
    if (!Files._isNullOREmpty(path)) {
      fileData.hasFile = true;
      fileData.fileName = Files.getFileName(path);
      fileData.path = path!;
    }
    return fileData;
  }

  /// function file view
  static viewFile(
      {required FileData fileData, Function(FileData fileData)? onView}) {
    try {
      String path = (!Files._isNullOREmpty(fileData.path))
          ? fileData.path
          : fileData.otherDevicePath;
      if (!Files._isNullOREmpty(path)) {
        if (onView != null) {
          onView(fileData);
        } else {
          if (Files.isHttpPath(path)) {
            Open.browser(url: path);
          } else {
            Open.localFile(filePath: path);
          }
        }
      } else {
        dev.log(Files._fileNotFound);
      }
    } catch (e) {
      dev.log(Files._fileCouldNotLoad);
    }
  }

  /// function file deletion
  static deleteFile(
      {required FileData fileData,
      required Function(FileData fileData) onDeleted}) async {
    fileData.hasFile = false;
    fileData.fileName = "";
    fileData.filePath = "";
    fileData.fileMimeType = "";
    fileData.path = "";
    fileData.otherDevicePath = "";
    onDeleted(fileData);
  }

  /// function file picker options
  static filePickerOptions(
      {required BuildContext context,
      required FileData fileData,
      required FileMode fileMode,
      required Function(FileData fileData) onSelected,
      Function(String message, int messageCode)? onCancel,
      bool crop = false,
      int? maxFileSizeInMB,
      bool cropOnlySquare = false,
      String cropperToolbarTitle = Files.cropperToolbarTitle,
      Color cropperToolbarColor = Files.cropperToolbarColor,
      Color cropperToolbarWidgetsColor = Files.cropperToolbarWidgetsColor,
      List<String> allowedExtensions = Files.allowedAllExtensions}) async {
    fileMode == FileMode.camera
        ? await Files.cameraPicker(
            fileData: fileData,
            crop: crop,
            maxFileSizeInMb: maxFileSizeInMB,
            cropOnlySquare: cropOnlySquare,
            cropperToolbarTitle: cropperToolbarTitle,
            cropperToolbarColor: cropperToolbarColor,
            cropperToolbarWidgetsColor: cropperToolbarWidgetsColor,
            onSelected: (fileData) {
              onSelected(fileData);
            },
            onCancel: (message, messageCode) {
              if (onCancel != null) {
                onCancel(message, messageCode);
              }
            })
        : fileMode == FileMode.gallery
            ? await Files.imagePicker(
                fileData: fileData,
                crop: crop,
                maxFileSizeInMb: maxFileSizeInMB,
                cropOnlySquare: cropOnlySquare,
                cropperToolbarTitle: cropperToolbarTitle,
                cropperToolbarColor: cropperToolbarColor,
                cropperToolbarWidgetsColor: cropperToolbarWidgetsColor,
                onSelected: (fileData) {
                  onSelected(fileData);
                },
                onCancel: (message, messageCode) {
                  if (onCancel != null) {
                    onCancel(message, messageCode);
                  }
                })
            : await Files.filePicker(
                fileData: fileData,
                maxFileSizeInMb: maxFileSizeInMB,
                allowedExtensions: allowedExtensions,
                onSelected: (fileData) {
                  onSelected(fileData);
                },
                onCancel: (message, messageCode) {
                  if (onCancel != null) {
                    onCancel(message, messageCode);
                  }
                });
  }

  /// function camera picker for take picture and save to temporary cache directory
  static cameraPicker(
      {required FileData fileData,
      required Function(FileData fileData) onSelected,
      Function(String message, int messageCode)? onCancel,
      bool crop = false,
      int? maxFileSizeInMb,
      bool cropOnlySquare = false,
      String cropperToolbarTitle = Files.cropperToolbarTitle,
      Color cropperToolbarColor = Files.cropperToolbarColor,
      Color cropperToolbarWidgetsColor =
          Files.cropperToolbarWidgetsColor}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      String filePath = "";
      if (crop) {
        CroppedFile? croppedImage = await Files._imageCrop(
            filePath: image.path,
            cropOnlySquare: cropOnlySquare,
            cropperToolbarTitle: cropperToolbarTitle,
            cropperToolbarColor: cropperToolbarColor,
            cropperToolbarWidgetsColor: cropperToolbarWidgetsColor);
        if (croppedImage != null) {
          filePath = croppedImage.path;
        }
      } else {
        filePath = image.path;
      }
      if (!Files._isNullOREmpty(filePath)) {
        if (maxFileSizeInMb != null &&
            Files.mb(File(filePath).readAsBytesSync().lengthInBytes) >
                maxFileSizeInMb) {
          dev.log(
              "[${Files._mcFPCForSize}] ${Files._fileMoreThanMB(maxFileSizeInMb)}");
          if (onCancel != null) {
            onCancel(
                Files._fileMoreThanMB(maxFileSizeInMb), Files._mcFPCForSize);
          }
          return;
        }
        FileData fileData = FileData(
            hasFile: true,
            fileName: Files.getFileName(filePath),
            filePath: filePath,
            fileMimeType: Files.getMimeType(filePath),
            path: filePath);
        onSelected(fileData);
      } else {
        dev.log("[${Files._mcFPCForCancel}] ${Files._filePickCancel}");
        if (onCancel != null) {
          onCancel(Files._filePickCancel, Files._mcFPCForCancel);
        }
        return;
      }
    } else {
      dev.log("[${Files._mcFPCForCancel}] ${Files._filePickCancel}");
      if (onCancel != null) {
        onCancel(Files._filePickCancel, Files._mcFPCForCancel);
      }
      return;
    }
  }

  /// function image picker for pick image from gallery and save to temporary cache directory
  static imagePicker(
      {required FileData fileData,
      required Function(FileData fileData) onSelected,
      Function(String message, int messageCode)? onCancel,
      bool crop = false,
      int? maxFileSizeInMb,
      bool cropOnlySquare = false,
      String cropperToolbarTitle = Files.cropperToolbarTitle,
      Color cropperToolbarColor = Files.cropperToolbarColor,
      Color cropperToolbarWidgetsColor =
          Files.cropperToolbarWidgetsColor}) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      String filePath = "";
      if (crop) {
        CroppedFile? croppedImage = await Files._imageCrop(
            filePath: image.path,
            cropOnlySquare: cropOnlySquare,
            cropperToolbarTitle: cropperToolbarTitle,
            cropperToolbarColor: cropperToolbarColor,
            cropperToolbarWidgetsColor: cropperToolbarWidgetsColor);
        if (croppedImage != null) {
          filePath = croppedImage.path;
        }
      } else {
        filePath = image.path;
      }
      if (!Files._isNullOREmpty(filePath)) {
        if (maxFileSizeInMb != null &&
            Files.mb(File(filePath).readAsBytesSync().lengthInBytes) >
                maxFileSizeInMb) {
          dev.log(
              "[${Files._mcFPCForSize}] ${Files._fileMoreThanMB(maxFileSizeInMb)}");
          if (onCancel != null) {
            onCancel(
                Files._fileMoreThanMB(maxFileSizeInMb), Files._mcFPCForSize);
          }
          return;
        }
        FileData fileData = FileData(
            hasFile: true,
            fileName: Files.getFileName(filePath),
            filePath: filePath,
            fileMimeType: Files.getMimeType(filePath),
            path: filePath);
        onSelected(fileData);
      } else {
        dev.log("[${Files._mcFPCForCancel}] ${Files._filePickCancel}");
        if (onCancel != null) {
          onCancel(Files._filePickCancel, Files._mcFPCForCancel);
        }
        return;
      }
    } else {
      dev.log("[${Files._mcFPCForCancel}] ${Files._filePickCancel}");
      if (onCancel != null) {
        onCancel(Files._filePickCancel, Files._mcFPCForCancel);
      }
      return;
    }
  }

  /// function file picker for pick any file and save to temporary cache directory
  static filePicker(
      {required FileData fileData,
      required Function(FileData fileData) onSelected,
      Function(String message, int messageCode)? onCancel,
      int? maxFileSizeInMb,
      List<String> allowedExtensions = const [
        Files.pdf,
        Files.doc,
        Files.docx,
        Files.xls,
        Files.xlsx,
        Files.ppt,
        Files.pptx,
        Files.png,
        Files.jpg,
        Files.jpeg
      ]}) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);
    if (result != null && result.files.single.path != null) {
      if (maxFileSizeInMb != null &&
          Files.mb(result.files.single.size) > maxFileSizeInMb) {
        dev.log(
            "[${Files._mcFPCForSize}] ${Files._fileMoreThanMB(maxFileSizeInMb)}");
        if (onCancel != null) {
          onCancel(Files._fileMoreThanMB(maxFileSizeInMb), Files._mcFPCForSize);
        }
        return;
      }
      FileData fileData = FileData(
          hasFile: true,
          fileName: result.files.single.name,
          filePath: result.files.single.path!,
          fileMimeType: Files.getMimeType(result.files.single.path!),
          path: result.files.single.path!);
      onSelected(fileData);
    } else {
      dev.log("[${Files._mcFPCForCancel}] ${Files._filePickCancel}");
      if (onCancel != null) {
        onCancel(Files._filePickCancel, Files._mcFPCForCancel);
      }
      return;
    }
  }

  /// function image cropper
  static Future<CroppedFile?> _imageCrop(
      {required String filePath,
      bool cropOnlySquare = false,
      String cropperToolbarTitle = Files.cropperToolbarTitle,
      Color cropperToolbarColor = Files.cropperToolbarColor,
      Color cropperToolbarWidgetsColor =
          Files.cropperToolbarWidgetsColor}) async {
    return await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: cropOnlySquare
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.original, CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: cropperToolbarTitle,
              toolbarColor: cropperToolbarColor,
              toolbarWidgetColor: cropperToolbarWidgetsColor,
              initAspectRatio: cropOnlySquare
                  ? CropAspectRatioPreset.square
                  : CropAspectRatioPreset.original,
              lockAspectRatio: cropOnlySquare ? true : false),
          IOSUiSettings(
              title: cropperToolbarTitle,
              aspectRatioLockEnabled: cropOnlySquare ? true : false)
        ]);
  }
}
