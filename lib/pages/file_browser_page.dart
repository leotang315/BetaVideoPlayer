import 'package:flutter/material.dart';
import 'package:beta_player/models/video_source.dart';
import 'package:beta_player/services/file_source_manager.dart';
import 'package:beta_player/models/file_item.dart';

class FileBrowserPage extends StatefulWidget {
  final VideoSourceBase source;
  final FileSourceManager fileManager;
  final String? initialPath; // 添加初始路径参数

  const FileBrowserPage({
    super.key,
    required this.source,
    required this.fileManager,
    this.initialPath,
  });

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> {
  String currentPath = '';
  List<FileItem> items = [];
  bool isLoading = false;
  List<String> selectedPaths = [];

  @override
  void initState() {
    super.initState();
    _initPath();
    _loadFiles();
  }

  void _initPath() {
    if (widget.initialPath != null) {
      currentPath = widget.initialPath!;
    } else {
      switch (widget.source.runtimeType) {
        case VideoSourceLocalPath:
          currentPath = (widget.source as VideoSourceLocalPath).path;
          break;
        case VideoSourceSmb:
          currentPath = (widget.source as VideoSourceSmb).path;
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: _buildFileItem,
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
      selectedPaths.clear();
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

  void _navigateToDirectory(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FileBrowserPage(
              source: widget.source,
              fileManager: widget.fileManager,
              initialPath: path, // 使用新路径
            ),
      ),
    );
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

  // 添加确认选择的方法
  void _confirmSelection() {
    // 返回选中的路径列表
    Navigator.pop(context, selectedPaths);
  }
}
