#ifndef FLUTTER_PLUGIN_FILE_PICKER_PRO_PLUGIN_H_
#define FLUTTER_PLUGIN_FILE_PICKER_PRO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace file_picker_pro {

class FilePickerProPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FilePickerProPlugin();

  virtual ~FilePickerProPlugin();

  // Disallow copy and assign.
  FilePickerProPlugin(const FilePickerProPlugin&) = delete;
  FilePickerProPlugin& operator=(const FilePickerProPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace file_picker_pro

#endif  // FLUTTER_PLUGIN_FILE_PICKER_PRO_PLUGIN_H_
