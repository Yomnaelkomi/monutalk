import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key, required this.UID}) : super(key: key);
  final String UID;

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? jsonResponse;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isEditingFirstName = false;
  bool isEditingLastName = false;
  bool isChangingPassword = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    loadImageFromPreferences();
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
          firstNameController.text = jsonResponse?['firstName'] ?? '';
          lastNameController.text = jsonResponse?['lastName'] ?? '';
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
        final updatedData = json.decode(response.body);
        setState(() {
          jsonResponse?['firstName'] = updatedData['firstName'];
          jsonResponse?['lastName'] = updatedData['lastName'];
          isLoading = false;
          isEditingFirstName = false;
          isEditingLastName = false;
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

  Future<void> changePassword() async {
    setState(() {
      isChangingPassword = !isChangingPassword;
      passwordController.clear();
      confirmPasswordController.clear();
      errorMessage = ''; // Clear any previous error message
    });
  }

  Future<void> submitChangePassword() async {
    final newPassword = passwordController.text.trim();
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
          passwordController.clear(); // Clear the password fields after successful update
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
      await saveImageToPreferences(pickedFile.path);
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
        final updatedData = json.decode(response.body);
        setState(() {
          jsonResponse?['imageUrl'] = updatedData['imageUrl'];
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

  Future<void> saveImageToPreferences(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', imagePath);
  }

  Future<void> loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (imageUrl != null && imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : const AssetImage('assets/images/contactImage.png')
                                      as ImageProvider),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _pickImage,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
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
                    },
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
                    },
                  ),
                  const SizedBox(height: 20),
                  if (isEditingFirstName || isEditingLastName) ...[
                    ElevatedButton(
                      onPressed: updateUser,
                      child: const Text('Update'),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Email Section
                  itemProfile(
                    'Email',
                    jsonResponse?['email'] ?? '', // Display email from jsonResponse
                    CupertinoIcons.mail,
                    null, // Pass null for email as it's not editable
                    false,
                    null,
                  ),
                  const SizedBox(height: 20),
                  // Change Password Section
                  ElevatedButton(
                    onPressed: changePassword,
                    child: const Text('Change Password'),
                  ),
                  if (isChangingPassword) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
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
    TextEditingController? controller, // Make controller nullable
    bool isEditing,
    VoidCallback? onEdit, // Make onEdit nullable
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.deepOrange.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: controller != null && isEditing
            ? TextField(
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
