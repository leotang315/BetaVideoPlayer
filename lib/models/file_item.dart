import 'dart:io' show FileSystemEntity, File, Directory, Platform;

abstract class FileItem {
  String get name;
  String get path;
  bool get isDirectory;
  DateTime? get modifiedTime;
  int? get size;
}

// 本地文件实现
class LocalFileItem implements FileItem {
  final FileSystemEntity _entity;
  
  LocalFileItem(this._entity);
  
  @override
  String get name => _entity.path.split(Platform.pathSeparator).last;
  
  @override
  String get path => _entity.path;
  
  @override
  bool get isDirectory => _entity is Directory;
  
  @override
  DateTime? get modifiedTime => (_entity is File) 
    ? (_entity as File).lastModifiedSync() 
    : null;
    
  @override
  int? get size => (_entity is File) 
    ? (_entity as File).lengthSync() 
    : null;
}

// SMB文件实现
class SmbFileItem implements FileItem {
  final String _name;
  final String _path;
  final bool _isDirectory;
  final DateTime? _modifiedTime;
  final int? _size;

  SmbFileItem({
    required String name,
    required String path,
    required bool isDirectory,
    DateTime? modifiedTime,
    int? size,
  }) : _name = name,
       _path = path,
       _isDirectory = isDirectory,
       _modifiedTime = modifiedTime,
       _size = size;

  @override
  String get name => _name;
  
  @override
  String get path => _path;
  
  @override
  bool get isDirectory => _isDirectory;
  
  @override
  DateTime? get modifiedTime => _modifiedTime;
  
  @override
  int? get size => _size;
}