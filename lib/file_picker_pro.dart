import 'file_picker_pro_platform_interface.dart';

class FilePickerPro {
  Future<String?> getPlatformVersion() {
    return FilePickerProPlatform.instance.getPlatformVersion();
  }
}
