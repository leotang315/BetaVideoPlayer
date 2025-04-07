class FileItem {
  final String name;
  final String path;
  final bool isDirectory;
  final DateTime? modifiedTime;
  final int? size;

  FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.modifiedTime,
    this.size,
  });
}
