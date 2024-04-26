import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  // Define variables to hold form data
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _message = "";

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Implement logic to send contact information (e.g., email or API call)
      print("Name: $_name, Email: $_email, Message: $_message");

      // Show a success message or redirect to a confirmation page
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Thank you for contacting us!'),
        ),
      );

      // Reset the form
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding:const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(
                'Get in Touch',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'We appreciate your feedback and inquiries. Feel free to reach out to us using the form below.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration:const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _name = value!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration:const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address.';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _email = value!),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration:const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  // minLines: 5,
                  // maxLines: 10,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your message.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _message = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child:const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
