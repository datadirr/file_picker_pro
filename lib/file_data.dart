class FileData {
  bool hasFile;
  String fileName;
  String filePath;
  String fileMimeType;
  String path;

  FileData(
      {this.hasFile = false,
      this.fileName = "",
      this.filePath = "",
      this.fileMimeType = "",
      this.path = ""});

  factory FileData.clone(FileData fileData) {
    return FileData(
        hasFile: fileData.hasFile,
        fileName: fileData.fileName,
        filePath: fileData.filePath,
        fileMimeType: fileData.fileMimeType,
        path: fileData.path);
  }
}
