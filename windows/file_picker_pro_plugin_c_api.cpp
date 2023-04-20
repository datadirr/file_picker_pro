#include "include/file_picker_pro/file_picker_pro_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "file_picker_pro_plugin.h"

void FilePickerProPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  file_picker_pro::FilePickerProPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
