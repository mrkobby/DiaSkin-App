import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

class Capture extends StatefulWidget {
  @override
  CaptureState createState() => CaptureState();
}

class CaptureState extends State<Capture> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady = false;
  bool showCamera = true;
  String imagePath;
  // Inputs
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: showCamera
                        ? Container(
                      height: 380,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Center(child: cameraPreviewWidget()),
                      ),
                    )
                        : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          imagePreviewWidget(),
                          editCaptureControlRowWidget(),
                        ]),
                  ),
                  showCamera ? captureControlRowWidget() : Container(),
                  cameraOptionsWidget(),
                  captureInputsWidget()
                ],
              ),
            )));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showInSnackBar('Camera error $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget cameraOptionsWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showCamera ? cameraTogglesRowWidget() : Container(),
        ],
      ),
    );
  }

  Widget cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras != null) {
      if (cameras.isEmpty) {
        return const Text('No camera found');
      } else {
        for (CameraDescription cameraDescription in cameras) {
          toggles.add(
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.08,
                right: MediaQuery.of(context).size.height * 0.00,
                top: 5,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 90.0,
                    child: RadioListTile<CameraDescription>(
                      secondary: Icon(
                        getCameraLensIcon(cameraDescription.lensDirection),
                        color: Color(0xFF1C0942),
                      ),
                      groupValue: controller?.description,
                      value: cameraDescription,
                      onChanged:
                      controller != null ? onNewCameraSelected : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return Row(children: toggles);
  }

  Widget captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.camera,
            size: 40.0,
            color: Colors.green,
          ),
          color: Colors.blue,
          onPressed: controller != null && controller.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  Widget captureInputsWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(fontSize: 16, color: Colors.black),
            controller: notesController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Notes (optional)',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return Container(
                width: 200,
                height: 40,
                child: RaisedButton(
                  onPressed: () => {},
                  color: Colors.white,
                  child: Text(
                    'Diagnose',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1C0942)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget editCaptureControlRowWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          icon: const Icon(
            Icons.camera_alt,
            size: 30.0,
            color: Colors.blueAccent,
          ),
          color: Colors.blue,
          onPressed: () => setState(() {
            showCamera = true;
          }),
        ),
      ),
    );
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          showCamera = false;
          imagePath = filePath;
        });
      }
    });
  }

  void showInSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/assets/';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException {
      return null;
    }
    return filePath;
  }

  Widget cameraPreviewWidget() {
    if (!isReady || !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget imagePreviewWidget() {
    return Container(
        decoration: new BoxDecoration(
          //borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: new Border.all(
            width: 0.1,
            color: Color(0xFF1C0942),
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: imagePath == null
              ? null
              : SizedBox(
            child: Image.file(File(imagePath)),
            height: 290.0,
          ),
        ));
  }
}
