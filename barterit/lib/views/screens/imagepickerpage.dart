import 'dart:io';
import 'package:barterit/views/screens/loginscreen.dart';
import 'package:barterit/views/screens/newpossessiontabscreen.dart';
import 'package:barterit/views/screens/registrationscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barterit/models/user.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerPage extends StatefulWidget {
  final User user;

  const ImagePickerPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool loginRequired = false;
  bool dialogShown = false;
  List<File?> _images = List.generate(3, (_) => null);
  var pathAsset = "assets/images/camera.jpg";
  late double screenHeight, screenWidth, cardwidth;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkLoginStatus();
  }
  void checkLoginStatus() {
    if (widget.user.name == "na" && !dialogShown) {
      if (!dialogShown) {
        setState(() {
          loginRequired = true;
        });
      }
      // User is not logged in or registered
    }
  }


  void showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Required"),
          content: Text("Please log in or sign up to access the profile."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogShown = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Log In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogShown = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text("Register"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    cardwidth = screenWidth / 3;
    
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Show login dialog after the frame is rendered
      if (loginRequired) {
        showLoginDialog();
        setState(() {
          loginRequired = false;
        });
      }
    });
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 7,
            child: GestureDetector(
              onTap: () {
                _selectFromCamera();
              },
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _images[_selectedImageIndex] == null
                        ? AssetImage(pathAsset)
                        : FileImage(_images[_selectedImageIndex]!)
                            as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: cardwidth,
                      height: cardwidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedImageIndex == index
                              ? Colors.blue
                              : Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: _images[index] != null
                          ? Image.file(
                              _images[index]!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                insertDialog();
              },
              child: Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _images[_selectedImageIndex] = File(pickedFile.path);
      });
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    if (_images[_selectedImageIndex] == null) {
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _images[_selectedImageIndex]!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      setState(() {
        _images[_selectedImageIndex] = imageFile;
      });

      int? sizeInBytes = _images[_selectedImageIndex]?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);
    }
  }

  void insertDialog() {
    if (_images.any((image) => image == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take three pictures")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Insert your picture?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewPossessionTabScreen(images: _images, user: widget.user),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
