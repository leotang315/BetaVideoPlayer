import 'dart:io';
import 'package:beta_player/models/file_item.dart';
import 'package:smb_connect/smb_connect.dart';

// abstract class FileSourceManager {
//   Future<List<FileItem>> listFiles(String path);
//   Future<void> deleteFiles(List<String> paths);
//   Future<void> copyFiles(List<String> sources, String destination);
//   Future<void> moveFiles(List<String> sources, String destination);
// }

// class LocalFileManager extends FileSourceManager {
//   @override
//   Future<void> deleteFiles(List<String> paths) async {
//     for (final path in paths) {
//       final file = File(path);
//       if (await file.exists()) {
//         await file.delete();
//       }
//     }
//   }

//   @override
//   Future<void> copyFiles(List<String> sources, String destination) async {
//     for (final source in sources) {
//       final sourceFile = File(source);
//       if (await sourceFile.exists()) {
//         final fileName = sourceFile.path.split(Platform.pathSeparator).last;
//         final destPath = '$destination${Platform.pathSeparator}$fileName';
//         await sourceFile.copy(destPath);
//       }
//     }
//   }

//   @override
//   Future<void> moveFiles(List<String> sources, String destination) async {
//     // 先复制文件
//     await copyFiles(sources, destination);
//     // 删除源文件
//     await deleteFiles(sources);
//   }

//   @override
//   Future<List<FileItem>> listFiles(String path) async {
//     final directory = Directory(path);
//     final entities = await directory.list().toList();
//     return entities.map((entity) => LocalFileItem(entity)).toList();
//   }

//   // 实现其他方法...
// }

// class SmbFileManager extends FileSourceManager {
//   late final SmbConnect _smbConnect;
//   final String _host;
//   final String _username;
//   final String _password;
//   final String _domain;
//   final int _port;
//   bool _isConnected = false;

//   SmbFileManager({
//     required String host,
//     required String username,
//     required String password,
//     String domain = '',
//     int port = 445,
//   }) : _host = host,
//        _username = username,
//        _password = password,
//        _domain = domain,
//        _port = port;

//   Future<void> _ensureConnected() async {
//     if (!_isConnected) {
//       _smbConnect = await SmbConnect.connectAuth(
//         host: _host,
//         domain: _domain,
//         username: _username,
//         password: _password,
//       );
//       _isConnected = true;
//     }
//   }

//   @override
//   Future<List<FileItem>> listFiles(String path) async {
//     await _ensureConnected();
//     final smbFolder = await _smbConnect.file(path);
//     final files = await _smbConnect.listFiles(smbFolder);

//     return files
//         .map(
//           (file) => SmbFileItem(
//             name: file.name,
//             path: file.path,
//             size: file.size,
//             isDirectory: file.isDirectory(),
//             modifiedTime: DateTime.fromMillisecondsSinceEpoch(
//               file.lastModified * 1000,
//             ),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Future<void> deleteFiles(List<String> paths) async {
//     await _ensureConnected();
//     for (final path in paths) {
//       final file = await _smbConnect.file(path);
//       if (file.isExists) {
//         await _smbConnect.delete(file);
//       }
//     }
//   }

//   @override
//   Future<void> copyFiles(List<String> sources, String destination) async {
//     await _ensureConnected();
//     for (final source in sources) {
//       final sourceFile = await _smbConnect.file(source);
//       if (sourceFile.isExists) {
//         final fileName = sourceFile.name;
//         final destPath = '$destination/$fileName';

//         // 读取源文件
//         final stream = await _smbConnect.openRead(sourceFile);
//         final bytes = await stream.reduce(
//           (a, b) => Uint8List.fromList([...a, ...b]),
//         );

//         // 创建并写入目标文件
//         final destFile = await _smbConnect.createFile(destPath);
//         final writer = await _smbConnect.openWrite(destFile);
//         writer.add(bytes);
//         await writer.flush();
//         await writer.close();
//       }
//     }
//   }

//   @override
//   Future<void> moveFiles(List<String> sources, String destination) async {
//     await _ensureConnected();
//     for (final source in sources) {
//       final sourceFile = await _smbConnect.file(source);
//       if (sourceFile.isExists) {
//         final fileName = sourceFile.name;
//         final destPath = '$destination/$fileName';
//         await _smbConnect.rename(sourceFile, destPath);
//       }
//     }
//   }

//   Future<void> dispose() async {
//     if (_isConnected) {
//       await _smbConnect.close();
//       _isConnected = false;
//     }
//   }
// }

// abstract class CloudFileManager extends FileSourceManager {
//   // 实现网盘相关操作...
// }

abstract class FileSourceManager {
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

  /// 重命名文件或目录
  Future<void> rename(String path, String newName);

  /// 判断文件或目录是否存在
  Future<bool> exists(String path);

  /// 读取文件内容
  Future<List<int>> read(String path);

  /// 写入文件内容
  Future<void> write(String path, List<int> data);

  /// 关闭资源
  Future<void> dispose();
}

class LocalFileManager extends FileSourceManager {
  @override
  Future<FileItem?> getItem(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return LocalFileItem(file);
    }
    return null;
  }

  @override
  Future<List<FileItem>> list(String path) async {
    final directory = Directory(path);
    final entities = await directory.list().toList();
    return entities.map((entity) => LocalFileItem(entity)).toList();
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
  Future<void> rename(String path, String newName) async {
    final file = File(path);
    if (await file.exists()) {
      final directory = file.parent.path;
      final newPath = '$directory${Platform.pathSeparator}$newName';
      await file.rename(newPath);
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

class SmbFileManager extends FileSourceManager {
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
      return SmbFileItem(
        name: file.name,
        path: file.path,
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
          (file) => SmbFileItem(
            name: file.name,
            path: file.path,
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
      await _smbConnect.rename(sourceFile, destination);
    }
  }

  @override
  Future<void> rename(String path, String newName) async {
    await _ensureConnected();
    final file = await _smbConnect.file(path);
    if (file.isExists) {
      final directory = file.path.substring(0, file.path.lastIndexOf('/'));
      final newPath = '$directory/$newName';
      await _smbConnect.rename(file, newPath);
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
    writer.add(data);
    await writer.flush();
    await writer.close();
  }

  @override
  Future<void> dispose() async {
    if (_isConnected) {
      await _smbConnect.close();
      _isConnected = false;
    }
  }
}
