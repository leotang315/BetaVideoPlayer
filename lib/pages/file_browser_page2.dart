import 'package:flutter/material.dart';
import 'package:beta_player/models/video_source.dart';
import 'package:beta_player/services/file_source_manager.dart';
import 'package:beta_player/models/file_item.dart';

class MySlideTransition extends AnimatedWidget {
  const MySlideTransition({
    Key? key,
    required Animation<Offset> position,
    this.transformHitTests = true,
    required this.child,
  }) : super(key: key, listenable: position);

  final bool transformHitTests;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<Offset>;
    Offset offset = position.value;
    if (position.status == AnimationStatus.reverse) {
      offset = Offset(-offset.dx, offset.dy);
    }
    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class FileBrowserPage2 extends StatefulWidget {
  final VideoSourceBase source;
  final FileManager fileManager;
  final String? initialPath;

  const FileBrowserPage2({
    super.key,
    required this.source,
    required this.fileManager,
    this.initialPath,
  });

  @override
  State<FileBrowserPage2> createState() => _FileBrowserPage2State();
}

class _FileBrowserPage2State extends State<FileBrowserPage2> {
  String currentPath = '';
  List<FileItem> items = [];
  bool isLoading = false;
  List<String> selectedPaths = [];
  final List<String> pathHistory = [];
  bool isForward = true;

  @override
  void initState() {
    super.initState();
    _initPath();
  }

  void _initPath() {
    if (widget.initialPath != null) {
      _navigateToDirectory(widget.initialPath!);
    } else {
      final initialPath = switch (widget.source) {
        VideoSourceLocalPath source => source.path,
        VideoSourceSmb source => source.path,
        _ => '',
      };
      _navigateToDirectory(initialPath);
    }
  }

  void _navigateToDirectory(String path) {
    setState(() {
      currentPath = path;
      pathHistory.add(path);
      isForward = true;
    });
    _loadFiles();
  }

  bool _navigateBack() {
    if (pathHistory.length > 1) {
      pathHistory.removeLast();
      setState(() {
        currentPath = pathHistory.last;
        isForward = false;
      });
      _loadFiles();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_navigateBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (!_navigateBack()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(currentPath),
          actions: [
            TextButton(
              child: Text(selectedPaths.isEmpty ? '全选' : '取消全选'),
              onPressed: _toggleSelectAll,
            ),
          ],
        ),
        body: Column(
          children: [
            if (isLoading) const LinearProgressIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return MySlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isForward ? 1.0 : -1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: child,
                  );
                },
                child: ListView.builder(
                  key: ValueKey<String>(currentPath),
                  itemCount: items.length,
                  itemBuilder: _buildFileItem,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            selectedPaths.isNotEmpty
                ? Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: ElevatedButton(
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('确定导入', style: TextStyle(fontSize: 16.0)),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, int index) {
    final item = items[index];
    final isSelected = selectedPaths.contains(item.path);

    return ListTile(
      leading: Icon(
        item.isDirectory ? Icons.folder : _getFileIcon(item.path),
        color: item.isDirectory ? Colors.blue : Colors.grey,
      ),
      title: Text(item.name),
      subtitle:
          !item.isDirectory
              ? Text(
                '${_formatFileSize(item.size)} - ${_formatDate(item.modifiedTime)}',
              )
              : null,
      trailing: Checkbox(
        value: isSelected,
        onChanged: (bool? value) => _toggleSelectItem(item.path),
      ),
      onTap: () {
        if (item.isDirectory) {
          _navigateToDirectory(item.path);
        }
      },
    );
  }

  Future<void> _loadFiles() async {
    setState(() => isLoading = true);
    try {
      items = await widget.fileManager.list(currentPath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _toggleSelectItem(String path) {
    setState(() {
      if (selectedPaths.contains(path)) {
        selectedPaths.remove(path);
      } else {
        selectedPaths.add(path);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (selectedPaths.isEmpty) {
        selectedPaths = items.map((item) => item.path).toList();
      } else {
        selectedPaths.clear();
      }
    });
  }

  String _formatFileSize(int? size) {
    if (size == null) return '';
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month}-${date.day}';
  }

  IconData _getFileIcon(String path) {
    final extension = path.toLowerCase().split('.').last;

    switch (extension) {
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
      case 'wmv':
        return Icons.video_file;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file;
      case 'txt':
      case 'doc':
      case 'docx':
      case 'pdf':
        return Icons.description;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _confirmSelection() {
    Navigator.pop(context, selectedPaths);
  }
}
