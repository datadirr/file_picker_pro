import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker_pro/file_picker_pro_method_channel.dart';

void main() {
  MethodChannelFilePickerPro platform = MethodChannelFilePickerPro();
  const MethodChannel channel = MethodChannel('file_picker_pro');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
