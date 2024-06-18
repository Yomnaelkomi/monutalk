import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPurchases extends StatefulWidget {
  const MyPurchases({super.key, required this.UID});
  final UID;
  @override
  State<MyPurchases> createState() {
    return _MyPurchasesState();
  }
}

class _MyPurchasesState extends State<MyPurchases> {
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  List<dynamic> jsonResponse = [];
  var jsonResponseID;

  Future<void> fetchPost() async {
    try {
      final uri = Uri.parse(
          'https://monu-talk-production.up.railway.app/tickets/users/${widget.UID}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load purchase data');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'My Purchases',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      )),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
              itemCount: jsonResponse.length,
              itemBuilder: (context, index) {
                final purchacedate = jsonResponse[index]['purchaseDate'];
                final quantity = jsonResponse[index]['quantity'];
                final ticketDate = jsonResponse[index]['ticketDate'];
                final nationality = jsonResponse[index]['nationality'];
                final phoneNb = jsonResponse[index]['phoneNumber'];
                final name = jsonResponse[index]['museumName'];
                return Container(
                  margin: const EdgeInsets.only(
                      left: 7, bottom: 5, top: 10, right: 7),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 42, 30, 5),
                      width: 8,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(
                          5.0,
                          5.0,
                        ), //Offset
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 7, top: 5, bottom: 5, right: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Purchase Date: $purchacedate',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'ticket Date: $ticketDate',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Museum Name: $name',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'quantity: ${quantity.toString()}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'nationality: $nationality',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Phone Number: $phoneNb',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
