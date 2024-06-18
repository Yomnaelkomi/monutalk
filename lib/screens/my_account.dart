import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key, required this.UID});
  final String UID;

  @override
  State<MyAccountPage> createState() {
    return _MyAccountPageState();
  }
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isLoading = true;
  String errorMessage = '';
  var jsonResponse;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool isEditingFirstName = false;
  bool isEditingLastName = false;
  File? _imageFile;

  // Password change fields
  bool isChangingPassword = false;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  Future<void> fetchPost() async {
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/auth/${widget.UID}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          firstNameController.text = jsonResponse['firstName'] ?? '';
          lastNameController.text = jsonResponse['lastName'] ?? '';
          isLoading = false;
        });
        print(jsonResponse);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/auth/${widget.UID}');
      final Map<String, String> updatedFields = {};

      if (firstNameController.text.isNotEmpty) {
        updatedFields['firstName'] = firstNameController.text;
      }
      if (lastNameController.text.isNotEmpty) {
        updatedFields['lastName'] = lastNameController.text;
      }

      final response = await http.patch(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedFields),
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          // Update the controllers with new data from the response
          firstNameController.text = jsonResponse['firstName'] ?? '';
          lastNameController.text = jsonResponse['lastName'] ?? '';
          isEditingFirstName = false;
          isEditingLastName = false;
          isLoading = false;
        });
        print(jsonResponse);
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse(
        'https://monu-talk-production.up.railway.app/auth/update-image/${widget.UID}');
    final request = http.MultipartRequest('PATCH', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          isLoading = false;
        });
        print(jsonResponse);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Toggle password change fields
  void changePassword() {
    setState(() {
      isChangingPassword = !isChangingPassword;
      newPasswordController.clear();
      confirmPasswordController.clear();
      errorMessage = ''; // Clear any previous error message
    });
  }

  // Submit new password
  Future<void> submitChangePassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.length < 6) {
      setState(() {
        errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/auth/change-password/${widget.UID}');
      final Map<String, String> passwordData = {
        'newPassword': newPassword,
      };

      final response = await http.patch(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(passwordData),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          newPasswordController.clear(); // Clear the password fields after successful update
          confirmPasswordController.clear();
          isChangingPassword = false;
          // Optionally, you can update the UI or display a success message
        });
        print('Password changed successfully');
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to change password: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic imageUrl = jsonResponse?['imageUrl'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (imageUrl != null && imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage('assets/images/contactImage.png')) as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon:const Icon(Icons.edit, color: Color.fromARGB(255, 233, 227, 227), size: 30),
                              onPressed: _pickImage,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      itemProfile(
                        'First Name', 
                        jsonResponse?['firstName'] ?? '', 
                        CupertinoIcons.person,
                        firstNameController,
                        isEditingFirstName,
                        () {
                          setState(() {
                            isEditingFirstName = !isEditingFirstName;
                          });
                        }
                      ),
                      const SizedBox(height: 10),
                      itemProfile(
                        'Last Name', 
                        jsonResponse?['lastName'] ?? '', 
                        CupertinoIcons.person,
                        lastNameController,
                        isEditingLastName,
                        () {
                          setState(() {
                            isEditingLastName = !isEditingLastName;
                          });
                        }
                      ),
                      const SizedBox(height: 20),
                      if (isEditingFirstName || isEditingLastName)
                        ElevatedButton(
                          onPressed: updateUser,
                          child: const Text('Update'),
                        ),
                      const SizedBox(height: 10),
                      itemProfile(
                        'Email', 
                        jsonResponse['email'], 
                        CupertinoIcons.mail,
                        null,
                        false,
                        null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: changePassword,
                        child: const Text('Change Password'),
                      ),
                      if (isChangingPassword) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: newPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Enter new password (min. 6 characters)',
                            errorText: errorMessage.isNotEmpty ? errorMessage : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm new password',
                            errorText: errorMessage.isNotEmpty ? errorMessage : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: submitChangePassword,
                          child: const Text('Submit'),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }


  Widget itemProfile(
      String title,
      String subtitle,
      IconData iconData,
      TextEditingController? controller,
      bool isEditing,
      VoidCallback? onEdit) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: isEditing
            ? TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter $title',
                ),
              )
            : Text(subtitle),
        leading: Icon(iconData),
        trailing: onEdit != null
            ? IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                onPressed: onEdit,
              )
            : null,
        tileColor: Colors.white,
      ),
    );
  }
}
