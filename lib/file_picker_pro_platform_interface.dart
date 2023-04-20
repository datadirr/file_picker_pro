import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'file_picker_pro_method_channel.dart';

abstract class FilePickerProPlatform extends PlatformInterface {
  /// Constructs a FilePickerProPlatform.
  FilePickerProPlatform() : super(token: _token);

  static final Object _token = Object();

  static FilePickerProPlatform _instance = MethodChannelFilePickerPro();

  /// The default instance of [FilePickerProPlatform] to use.
  ///
  /// Defaults to [MethodChannelFilePickerPro].
  static FilePickerProPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FilePickerProPlatform] when
  /// they register themselves.
  static set instance(FilePickerProPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
