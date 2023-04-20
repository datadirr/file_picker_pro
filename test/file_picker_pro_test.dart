import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker_pro/file_picker_pro.dart';
import 'package:file_picker_pro/file_picker_pro_platform_interface.dart';
import 'package:file_picker_pro/file_picker_pro_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFilePickerProPlatform
    with MockPlatformInterfaceMixin
    implements FilePickerProPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FilePickerProPlatform initialPlatform = FilePickerProPlatform.instance;

  test('$MethodChannelFilePickerPro is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFilePickerPro>());
  });

  test('getPlatformVersion', () async {
    FilePickerPro filePickerProPlugin = FilePickerPro();
    MockFilePickerProPlatform fakePlatform = MockFilePickerProPlatform();
    FilePickerProPlatform.instance = fakePlatform;

    expect(await filePickerProPlugin.getPlatformVersion(), '42');
  });
}
