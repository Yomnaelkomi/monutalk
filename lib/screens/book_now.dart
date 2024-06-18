import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:final5/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//import 'package:forms/models/grocery_item.dart';
final formatter = DateFormat.yMd();

class BookNowScreen extends StatefulWidget {
  const BookNowScreen(
      {super.key,
      required this.MusuemId,
      required this.UID,
      required this.name,
      required this.price});
  final MusuemId;
  final UID;
  final name;
  final price;

  @override
  State<BookNowScreen> createState() {
    return _BookNowScreenState();
  }
}

class _BookNowScreenState extends State<BookNowScreen> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Country country = CountryParser.parseCountryCode('EG');
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _nationality = '';
  var _enteredQuantity = 1;
  final _email = '';
  var _phonenumber;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: DateTime(2100));
    setState(() {
      _selectedDate = pickedDate;
    });
    print('sssssssssssss$_selectedDate');
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'monu-talk-production.up.railway.app', // Authority
          '/tickets');
      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'ticketDate': _selectedDate.toString(),
            'phoneNumber': _phonenumber,
            'nationality': _nationality,
            'quantity': _enteredQuantity,
            'museumId': widget.MusuemId.toString(),
            'userId': widget.UID,
          },
        ),
      );
      Get.to(PaymentScreen(
        ID: widget.MusuemId,
        UID: widget.UID,
        name: widget.name,
      ));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Booked succesfully'),
      //   ),
      // );
      // // Navigator.of(context).pop();
    }
  }

  void showPicker() {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
            bottomSheetHeight: 600,
            borderRadius: BorderRadius.circular(20),
            inputDecoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search your country here',
                border: InputBorder.none)),
        onSelect: (country) {
          setState(() {
            this.country = country;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Now'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // if (value == null) {
                    //   return;
                    // }
                    _enteredName = value!;
                  },
                ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     labelText: 'Email',
                //   ),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your email address.';
                //     } else if (!RegExp(
                //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                //         .hasMatch(value)) {
                //       return 'Please enter a valid email address.';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) => setState(() => _email = value!),
                // ),
                // const SizedBox(
                //   height: 12,
                // ),

                // instead of TextField()
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('nationality'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // if (value == null) {
                    //   return;
                    // }
                    _nationality = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid, positive number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredQuantity = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? 'no date selected'
                            : formatter.format(
                                (_selectedDate!))), //! we tell dart that it will never be null
                        IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                

                const SizedBox(
                  height: 12,
                ),

                TextFormField(
                  onFieldSubmitted: (phoneNumber) {},
                  decoration: InputDecoration(
                      // filled: true,
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Enter phone number',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: GestureDetector(
                          onTap: showPicker,
                          child: Container(
                            height: 55,
                            width: 100,
                            alignment: Alignment.center,
                            child: Text(
                              '${country.flagEmoji}+${country.phoneCode}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ))),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    _phonenumber = value!;
                  },
                ),
                const SizedBox(height: 12),
                Text('Ticket Price ${widget.price} L.E'),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

