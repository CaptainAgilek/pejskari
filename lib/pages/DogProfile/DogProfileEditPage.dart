import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pejskari/data/DogProfile.dart';
import 'package:pejskari/forms/DogProfileEditForm.dart';
import 'package:pejskari/service/DogProfileService.dart';

/// This class represents page for editing dog profile.
class DogProfileEditPage extends StatefulWidget {
  const DogProfileEditPage({Key? key}) : super(key: key);

  static const String routeName = "/dog-profiles/edit";

  @override
  _DogProfileEditPageState createState() => _DogProfileEditPageState();
}

class _DogProfileEditPageState extends State<DogProfileEditPage> {
  DogProfileService dogProfileService = DogProfileService();
  bool isNewProfile = false;
  String _profileImagePath = "";
  DogProfile? _receivedDogProfile;

  /// This method saves (insert or update) dog profile to database.
  _onSave(DogProfile dogProfile) {
    dogProfile.profileImagePath = _profileImagePath;
    if (isNewProfile) {
      var insert = dogProfileService.create(dogProfile);
      isNewProfile = false;
    } else {
      dogProfileService.update(dogProfile);
    }
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Uloženo")));
  }

  /// This method shows dialog for selecting photo.
  Future<void> _showSelectPhotoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Vyberte odkud chcete nahrát fotografii."),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Galerie"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    const Padding(padding: const EdgeInsets.all(16.0)),
                    GestureDetector(
                      child: const Text("Fotoaparát"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  /// This method allows user to load image from gallery.
  void _openGallery(BuildContext context) async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    var applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    if (picture != null) {
      File file = File(picture.path);
      final savedImage = await file
          .copy('${applicationDocumentsDirectory.path}/${picture.name}');
      setState(() {
        _profileImagePath = savedImage.path;
      });
    }
    Navigator.of(context).pop();
  }

  /// This method allows user to take image from camera.
  void _openCamera(BuildContext context) async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);
    var applicationDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    if (picture != null) {
      File file = File(picture.path);
      final savedImage = await file
          .copy('${applicationDocumentsDirectory.path}/${picture.name}');
      setState(() {
        _profileImagePath = savedImage.path;
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //extract dog profile from arguments
    final _args = ModalRoute.of(context)!.settings.arguments;
    _receivedDogProfile = _args is DogProfile ? _args : null;
    isNewProfile = (_receivedDogProfile == null);

    if (_profileImagePath.isEmpty) {
      _profileImagePath = _receivedDogProfile?.profileImagePath ?? "";
    }

    //if received dog profile is null, create new empty dog profile
    _receivedDogProfile ??= DogProfile(0, "", "", "",
        DateTime.now().toIso8601String(), null, _profileImagePath, 0, 0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil psa " + _receivedDogProfile!.name),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        },
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                CircleAvatar(
                    radius: 70,
                    backgroundImage: _profileImagePath == ""
                        ? Image.asset("assets/dog_avatar.png").image
                        : Image.file(
                            File(_profileImagePath),
                            fit: BoxFit.cover,
                          ).image),
                Expanded(
                    child: Align(
                        child: IconButton(
                            onPressed: () {
                              _showSelectPhotoDialog(context);
                            },
                            icon: const Icon(Icons.photo_camera)))),
              ],
            ),
            Expanded(
                child: DogProfileEditForm(
                    dogProfile: _receivedDogProfile, onSubmit: _onSave))
          ],
        ),
      ),
    );
  }
}
