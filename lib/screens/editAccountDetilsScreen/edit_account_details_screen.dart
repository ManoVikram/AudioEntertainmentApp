import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/provider/user_data.dart';

import '../../models/bloc/updateUserData/update_user_data_bloc.dart';

class EditAccountDetilsScreen extends StatefulWidget {
  const EditAccountDetilsScreen({Key? key}) : super(key: key);

  static const String routeName = "/editAccountDetailsScreen";

  @override
  State<EditAccountDetilsScreen> createState() =>
      _EditAccountDetilsScreenState();
}

class _EditAccountDetilsScreenState extends State<EditAccountDetilsScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  final _imagePicker = ImagePicker();

  XFile? _selectedProfilePicture;

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUserData =
        context.watch<CurrentUserData>().currentUser;

    final UpdateUserDataBloc updateUserDataBloc =
        context.watch<UpdateUserDataBloc>();

    _nameController.text = currentUserData.name ?? "";
    _bioController.text = currentUserData.description ?? "";

    return BlocConsumer<UpdateUserDataBloc, UpdateUserDataState>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Text(
                "Updated Successfully!",
              ),
              titleTextStyle: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              content: Text(
                "Close the app and open it again to see the changes!",
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    // For 2 pops
                    /* int count = 0;
                    Navigator.of(context).popUntil((route) {
                      return count++ == 2;
                    }); */
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        } else if (state is UpdateUserDataError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? "Oops!! ERROR Updating Your Data!"),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            // Icons.arrow_back_ios_new,
                            Icons.close,
                            size: 36,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_selectedProfilePicture == null) {
                              updateUserDataBloc.add(
                                UpdateUserData(
                                  // userID: currentUserData.userID,
                                  email: currentUserData.email,
                                  name: _nameController.text,
                                  description: _bioController.text,
                                ),
                              );
                            } else {
                              updateUserDataBloc.add(
                                UpdateUserData(
                                  // userID: currentUserData.userID,
                                  email: currentUserData.email,
                                  name: _nameController.text,
                                  description: _bioController.text,
                                  profilePicture:
                                      File(_selectedProfilePicture!.path),
                                ),
                              );
                            }
                          },
                          icon: state is UpdateUserDataInProgress
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.redAccent),
                                )
                              : const Icon(Icons.done_rounded),
                          iconSize: 36,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                image: _selectedProfilePicture == null
                                    ? (currentUserData.profilePictureURL == null
                                        ? const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/DefaultProfilePicture.jpg"),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image: NetworkImage(""),
                                            fit: BoxFit.cover,
                                          ))
                                    : DecorationImage(
                                        image: FileImage(
                                          File(_selectedProfilePicture!.path),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final XFile? pickedImage = await _imagePicker
                                    .pickImage(source: ImageSource.gallery);

                                setState(() {
                                  _selectedProfilePicture = pickedImage;
                                });
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 20,
                      ),
                      maxLength: 50,
                      cursorHeight: 24,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Text(
                      "Bio/Description",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextField(
                      controller: _bioController,
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontSize: 20,
                      ),
                      minLines: 1,
                      maxLines: 7,
                      maxLength: 200,
                      textInputAction: TextInputAction.unspecified,
                      cursorHeight: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
