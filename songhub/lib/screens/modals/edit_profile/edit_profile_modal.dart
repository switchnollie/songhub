import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/buttons.dart';
// import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/screens/modals/edit_profile/edit_profile_view_model.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/user_profile.dart';

class EditProfileModal extends StatelessWidget {
  static const routeId = "/profile/edit";

  static Widget create(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);

    return Provider<EditProfileViewModel>(
      create: (_) => EditProfileViewModel(
          database: database,
          storageService: storageService,
          authService: authService),
      child: EditProfileModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EditProfileViewModel>(context);
    return StreamBuilder<UserProfile>(
      stream: vm.userProfile,
      builder: (context, snapshot) => Scaffold(
        body:
            snapshot.hasData ? EditProfileForm(user: snapshot.data) : Spinner(),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final UserProfile user;
  EditProfileForm({this.user});

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
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
      _firstNameController =
          TextEditingController(text: widget.user.userDocument.firstName);
      _lastNameController =
          TextEditingController(text: widget.user.userDocument.lastName);
      _stageNameController =
          TextEditingController(text: widget.user.userDocument.stageName);
      _selectedRole = widget.user.userDocument.role;
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

  void _handleSubmit(BuildContext context) async {
    try {
      if (_imageFile != null) {
        final storage = Provider.of<StorageService>(context, listen: false);
        await storage.uploadProfileImg(widget.user.userDocument.id, _imageFile);
      }
      if (_formKey.currentState.validate()) {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final newUser = User(
          id: widget.user.userDocument.id,
          email: widget.user.userDocument.email,
          firstName:
              _firstNameController.text ?? widget.user.userDocument.firstName,
          lastName:
              _lastNameController.text ?? widget.user.userDocument.lastName,
          stageName:
              _stageNameController.text ?? widget.user.userDocument.stageName,
          role: _selectedRole ?? widget.user.userDocument.role,
        );
        await database.setUser(newUser);
        showSnackBarByContext(context, "Your profile has been updated!");
      }
    } catch (err) {
      print(err);
      if (err is StorageError) {
        showSnackBarByContext(
            context, "An error occured: profile image upload failed",
            isError: true);
      } else {
        showSnackBarByContext(context, "An error occured: data upload failed",
            isError: true);
      }
    }
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
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRow(
                    ImageInput(
                      imageFile: _imageFile,
                      onPicked: _handleImagePicked,
                      imageUrl: widget.user.profileImgUrl,
                      isAvatar: false,
                      label: 'Image',
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        _buildRow(
                          TextInput(
                            label: 'First name',
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
                            label: 'Last name',
                            controller: _lastNameController,
                            icon: Icons.group,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a last name';
                              }
                              return null;
                            },
                            hintText: "Last Name",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildRow(
                TextInput(
                  label: 'Stage name',
                  controller: _stageNameController,
                  icon: Icons.face,
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
                  label: 'Role',
                  items: [
                    "Song Writer",
                    "Producer",
                  ],
                  icon: Icons.work,
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
                  onPressed: () => _handleSubmit(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
