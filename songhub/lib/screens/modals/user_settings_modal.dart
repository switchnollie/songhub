import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class UserSettingsModal extends StatelessWidget {
  static const routeId = "/profile/edit";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    print(user.toString());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("User Settings"),
        elevation: 0.0,
      ),
      body: UserSettingsForm(user: user),
      backgroundColor: Colors.white,
    );
  }
}

class UserSettingsForm extends StatefulWidget {
  final User user;
  UserSettingsForm({this.user});

  @override
  _UserSettingsFormState createState() => _UserSettingsFormState();
}

class _UserSettingsFormState extends State<UserSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController,
      _lastNameController,
      _stageNameController;

  File _imageFile;
  String _selectedRole;

  /// Init state
  @override
  void initState() {
    if (widget.user != null) {
      _firstNameController = TextEditingController(text: widget.user.firstName);
      _lastNameController = TextEditingController(text: widget.user.lastName);
      _stageNameController = TextEditingController(text: widget.user.stageName);
      _selectedRole = widget.user.role;
    }
    super.initState();
  }

  void _handleImagePicked(PickedFile image) async {
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _handleSubmit() async {
    if (_imageFile != null) {
      await StorageService().uploadProfileImg(widget.user.id, _imageFile);
    }
    if (_formKey.currentState.validate()) {
      await DatabaseService().updateUserData(
        _firstNameController.text ?? widget.user.firstName,
        _lastNameController.text ?? widget.user.lastName,
        _stageNameController.text ?? widget.user.stageName,
        _selectedRole ?? widget.user.role,
      );
    }
    Navigator.pop(context);
  }

  Widget _buildRow(Widget wrappedWidget) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: wrappedWidget,
    );
  }

  /// Dispose forms
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _stageNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildRow(
                ImageInput(
                  imageFile: _imageFile,
                  onPicked: _handleImagePicked,
                  imageUrl: widget.user.profileImgUrl,
                  isAvatar: true,
                ),
              ),
              _buildRow(
                TextInput(
                  controller: _firstNameController,
                  icon: Icons.person,
                  hintText: "First Name",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                ),
              ),
              _buildRow(
                TextInput(
                  controller: _lastNameController,
                  icon: Icons.person,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  hintText: "Last Name",
                ),
              ),
              _buildRow(
                TextInput(
                  controller: _stageNameController,
                  icon: Icons.person,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a stage name';
                    }
                    return null;
                  },
                  hintText: "Stage Name",
                ),
              ),
              _buildRow(
                DropdownInput(
                  items: [
                    "Song Writer",
                    "Producer",
                  ],
                  icon: Icons.label,
                  value: _selectedRole,
                  initialValue: "Song Writer",
                  onChanged: (newVal) {
                    setState(() {
                      _selectedRole = newVal;
                    });
                  },
                ),
              ),
              _buildRow(
                PrimaryButton(
                  text: "SAVE",
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
