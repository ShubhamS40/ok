import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PaperListScreen extends StatelessWidget {
  final List<dynamic> papers;

  const PaperListScreen({Key? key, required this.papers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Papers",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0E17D2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: papers.length,
        itemBuilder: (context, index) {
          var paper = papers[index];

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Paper Title
                  Text(
                    paper["title"],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 5),
                  Text("Year: ${paper["year"]}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Exam Type: ${paper["examType"]}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),

                  // Thumbnail & Full-Screen View Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenPaperView(imageUrl: paper["fileUrl"]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        paper["fileUrl"],
                        height: 150, // Small preview
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenPaperView(imageUrl: paper["fileUrl"]),
                          ),
                        );
                      },
                      child: const Text("View Full Paper",
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Full-Screen View Page with Zoom, Rotate, Reset & Download
class FullScreenPaperView extends StatefulWidget {
  final String imageUrl;

  const FullScreenPaperView({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  _FullScreenPaperViewState createState() => _FullScreenPaperViewState();
}

class _FullScreenPaperViewState extends State<FullScreenPaperView> {
  final TransformationController _transformationController =
      TransformationController();
  double _rotationAngle = 0.0;
  bool _isDownloading = false;

  void _rotateImage() {
    setState(() {
      _rotationAngle += pi / 2; // Rotate by 90 degrees
    });
  }

  void _resetTransform() {
    setState(() {
      _transformationController.value = Matrix4.identity();
      _rotationAngle = 0.0;
    });
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      // Request Storage Permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied!")),
          );
          return;
        }
      }

      setState(() {
        _isDownloading = true;
      });

      // Get storage directory
      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to get storage directory!")),
        );
        return;
      }

      String filePath = "${dir.path}/${imageUrl.split('/').last}";

      // Download File
      Dio dio = Dio();
      await dio.download(imageUrl, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloaded to: $filePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetTransform, // Reset zoom & rotation
          ),
          IconButton(
            icon: const Icon(Icons.rotate_right, color: Colors.white),
            onPressed: _rotateImage, // Rotate image
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                panEnabled: true,
                minScale: 0.2,
                maxScale: 10.0,
                child: AnimatedRotation(
                  turns: _rotationAngle / (2 * pi), // Converts radians to turns
                  duration: const Duration(milliseconds: 300),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.network(
                        widget.imageUrl,
                        width: (_rotationAngle % pi == 0)
                            ? constraints.maxWidth
                            : constraints.maxHeight,
                        height: (_rotationAngle % pi == 0)
                            ? constraints.maxHeight
                            : constraints.maxWidth,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Download Button
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isDownloading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.download),
              label: _isDownloading
                  ? const Text("Downloading...")
                  : const Text("Download Paper"),
              onPressed: _isDownloading
                  ? null
                  : () {
                      _downloadImage(context, widget.imageUrl);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
