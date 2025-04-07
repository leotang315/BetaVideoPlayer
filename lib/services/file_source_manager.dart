import 'dart:io';
import 'package:beta_player/models/file_item.dart';
import 'package:smb_connect/smb_connect.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'dart:typed_data';

abstract class FileManager {
  /// 获取文件/目录信息
  Future<FileItem?> getItem(String path);

  /// 列出目录内容
  Future<List<FileItem>> list(String path);

  /// 创建目录
  Future<void> createDirectory(String path);

  /// 创建文件
  Future<void> createFile(String path);

  /// 删除文件或目录
  Future<void> delete(String path);

  /// 复制文件或目录
  Future<void> copy(String source, String destination);

  /// 移动文件或目录
  Future<void> move(String source, String destination);

  /// 判断文件或目录是否存在
  Future<bool> exists(String path);

  /// 读取文件内容
  Future<List<int>> read(String path);

  /// 写入文件内容
  Future<void> write(String path, List<int> data);

  /// 关闭资源
  Future<void> dispose();
}

class LocalFileManager extends FileManager {
  @override
  Future<FileItem?> getItem(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final stat = await file.stat();
      return FileItem(
        name: file.uri.pathSegments.last,
        path: path,
        size: stat.size,
        isDirectory: stat.type == FileSystemEntityType.directory,
        modifiedTime: stat.modified,
      );
    }
    return null;
  }

  @override
  Future<List<FileItem>> list(String path) async {
    final directory = Directory(path);
    final entities = await directory.list().toList();
    return Future.wait(
      entities.map((entity) async {
        final stat = await entity.stat();
        return FileItem(
          name: entity.uri.pathSegments.last,
          path: entity.path,
          size: stat.size,
          isDirectory: stat.type == FileSystemEntityType.directory,
          modifiedTime: stat.modified,
        );
      }),
    );
  }

  @override
  Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    await directory.create(recursive: true);
  }

  @override
  Future<void> createFile(String path) async {
    final file = File(path);
    await file.create(recursive: true);
  }

  @override
  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete(recursive: true);
    }
  }

  @override
  Future<void> copy(String source, String destination) async {
    final sourceFile = File(source);
    if (await sourceFile.exists()) {
      await sourceFile.copy(destination);
    }
  }

  @override
  Future<void> move(String source, String destination) async {
    final sourceFile = File(source);
    if (await sourceFile.exists()) {
      await sourceFile.rename(destination);
    }
  }

  @override
  Future<bool> exists(String path) async {
    return File(path).exists();
  }

  @override
  Future<List<int>> read(String path) async {
    final file = File(path);
    return file.readAsBytes();
  }

  @override
  Future<void> write(String path, List<int> data) async {
    final file = File(path);
    await file.writeAsBytes(data);
  }

  @override
  Future<void> dispose() async {
    // 本地文件系统不需要特殊的清理操作
  }
}

class SmbFileManager extends FileManager {
  late final SmbConnect _smbConnect;
  final String _host;
  final String _username;
  final String _password;
  final String _domain;
  bool _isConnected = false;

  SmbFileManager({
    required String host,
    required String username,
    required String password,
    String domain = '',
  }) : _host = host,
       _username = username,
       _password = password,
       _domain = domain;

  Future<void> _ensureConnected() async {
    if (!_isConnected) {
      _smbConnect = await SmbConnect.connectAuth(
        host: _host,
        domain: _domain,
        username: _username,
        password: _password,
      );
      _isConnected = true;
    }
  }

  @override
  Future<FileItem?> getItem(String path) async {
    await _ensureConnected();
    final file = await _smbConnect.file(path);
    if (file.isExists) {
      return FileItem(
        name: file.name ?? path.split(Platform.pathSeparator).last,
        path: file.path ?? path,
        size: file.size,
        isDirectory: file.isDirectory(),
        modifiedTime: DateTime.fromMillisecondsSinceEpoch(
          file.lastModified * 1000,
        ),
      );
    }
    return null;
  }

  @override
  Future<List<FileItem>> list(String path) async {
    await _ensureConnected();
    final folder = await _smbConnect.file(path);
    final files = await _smbConnect.listFiles(folder);
    return files
        .map(
          (file) => FileItem(
            name:
                file.name ??
                file.path?.split(Platform.pathSeparator).last ??
                '',
            path: file.path ?? '',
            size: file.size,
            isDirectory: file.isDirectory(),
            modifiedTime: DateTime.fromMillisecondsSinceEpoch(
              file.lastModified * 1000,
            ),
          ),
        )
        .toList();
  }

  @override
  Future<void> createDirectory(String path) async {
    await _ensureConnected();
    await _smbConnect.createFolder(path);
  }

  @override
  Future<void> createFile(String path) async {
    await _ensureConnected();
    await _smbConnect.createFile(path);
  }

  @override
  Future<void> delete(String path) async {
    await _ensureConnected();
    final file = await _smbConnect.file(path);
    if (file.isExists) {
      await _smbConnect.delete(file);
    }
  }

  @override
  Future<void> copy(String source, String destination) async {
    await _ensureConnected();
    final sourceFile = await _smbConnect.file(source);
    if (sourceFile.isExists) {
      final stream = await _smbConnect.openRead(sourceFile);
      final writer = await _smbConnect.openWrite(
        await _smbConnect.createFile(destination),
      );
      try {
        await for (final chunk in stream) {
          writer.add(chunk);
        }
        await writer.flush();
      } finally {
        await writer.close();
      }
    }
  }

  @override
  Future<void> move(String source, String destination) async {
    await _ensureConnected();
    final sourceFile = await _smbConnect.file(source);
    if (sourceFile.isExists) {
      try {
        await _smbConnect.rename(sourceFile, destination);
      } catch (e) {
        // 如果重命名失败，尝试使用复制和删除的方式
        await copy(source, destination);
        await delete(source);
      }
    }
  }

  @override
  Future<bool> exists(String path) async {
    await _ensureConnected();
    final file = await _smbConnect.file(path);
    return file.isExists;
  }

  @override
  Future<List<int>> read(String path) async {
    await _ensureConnected();
    final file = await _smbConnect.file(path);
    final stream = await _smbConnect.openRead(file);
    final chunks = <int>[];
    await for (final chunk in stream) {
      chunks.addAll(chunk);
    }
    return chunks;
  }

  @override
  Future<void> write(String path, List<int> data) async {
    await _ensureConnected();
    final file = await _smbConnect.createFile(path);
    final writer = await _smbConnect.openWrite(file);
    try {
      writer.add(data);
      await writer.flush();
    } finally {
      await writer.close();
    }
  }

  @override
  Future<void> dispose() async {
    if (_isConnected) {
      await _smbConnect.close();
      _isConnected = false;
    }
  }
}

class WebdavFileManager extends FileManager {
  late webdav.Client _client;
  final String _baseUrl;
  final String _username;
  final String _password;
  bool _isConnected = false;

  WebdavFileManager({
    required String baseUrl,
    required String username,
    required String password,
  }) : _baseUrl = baseUrl,
       _username = username,
       _password = password;

  Future<void> _ensureConnected() async {
    if (!_isConnected) {
      _client = webdav.newClient(
        _baseUrl,
        user: _username,
        password: _password,
        debug: true,
      );
      _isConnected = true;
    }
  }

  @override
  Future<FileItem?> getItem(String path) async {
    await _ensureConnected();
    try {
      final file = await _client.readProps(path);
      return FileItem(
        name: file.name ?? path.split(Platform.pathSeparator).last,
        path: file.path ?? path,
        size: file.size,
        isDirectory: file.isDir ?? false,
        modifiedTime: file.mTime ?? DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<FileItem>> list(String path) async {
    await _ensureConnected();
    final files = await _client.readDir(path);
    return files
        .where((file) => file.name != null && file.path != null)
        .map(
          (file) => FileItem(
            name:
                file.name ??
                file.path?.split(Platform.pathSeparator).last ??
                '',
            path: file.path ?? '',
            size: file.size,
            isDirectory: file.isDir ?? false,
            modifiedTime: file.mTime ?? DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<void> createDirectory(String path) async {
    await _ensureConnected();
    await _client.mkdir(path);
  }

  @override
  Future<void> createFile(String path) async {
    await _ensureConnected();
    await _client.write(path, Uint8List(0));
  }

  @override
  Future<void> delete(String path) async {
    await _ensureConnected();
    await _client.remove(path);
  }

  @override
  Future<void> copy(String source, String destination) async {
    await _ensureConnected();
    await _client.copy(source, destination, false);
  }

  @override
  Future<void> move(String source, String destination) async {
    await _ensureConnected();
    // 先复制文件
    await copy(source, destination);
    // 然后删除源文件
    await delete(source);
  }

  @override
  Future<bool> exists(String path) async {
    await _ensureConnected();
    try {
      await _client.readProps(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<int>> read(String path) async {
    await _ensureConnected();
    final bytes = await _client.read(path);
    return bytes;
  }

  @override
  Future<void> write(String path, List<int> data) async {
    await _ensureConnected();
    await _client.write(path, Uint8List.fromList(data));
  }

  @override
  Future<void> dispose() async {
    if (_isConnected) {
      _isConnected = false;
    }
  }
}
