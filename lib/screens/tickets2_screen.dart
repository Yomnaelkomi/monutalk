import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Ticket2Screen extends StatefulWidget {
  const Ticket2Screen({super.key, required this.UID});
  final String UID;

  static List<Color> colors = [
    Colors.red,
    Colors.teal,
    Colors.purple,
    const Color.fromARGB(255, 243, 185, 99)
  ];

  @override
  State<Ticket2Screen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<Ticket2Screen> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> jsonResponse = [];
  List<dynamic> previousTickets = [];
  List<dynamic> upcomingTickets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.wait([fetchUpcomingPost(), fetchPreviousPost()]);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUpcomingPost() async {
    final uri = Uri.parse(
        'https://monu-talk-production.up.railway.app/tickets/users/${widget.UID}?date=upcoming');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        upcomingTickets = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load purchase data');
    }
  }

  Future<void> fetchPreviousPost() async {
    final uri = Uri.parse(
        'https://monu-talk-production.up.railway.app/tickets/users/${widget.UID}?date=prev');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        previousTickets = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load purchase data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 170, 217, 241),
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade600,
          title: const Text(
            'Tickets',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            
            tabs: [
              Tab(text: 'Previous'),
              Tab(text: 'Upcoming'),
              
            ],
            
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Color.fromARGB(255, 249, 249, 249)),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
              
                children: [
                  buildTicketList(previousTickets),
                  buildTicketList(upcomingTickets),
                ],
              ),
      ),
    );
  }

  Widget buildTicketList(List<dynamic> tickets) {
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets available.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(15),
      shrinkWrap: true,
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final ticketDate = DateTime.parse(ticket['ticketDate']);
        final name = ticket['museumName'];
        final quantity = ticket['quantity'];
        final ticketPrice = ticket['totalPrice'];
        final phoneNb = ticket['phoneNumber'];

        return Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          child: Stack(children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Ticket2Screen
                        .colors[index % Ticket2Screen.colors.length],
                    child: Center(
                        child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket #${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Row(children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Column(children: [
                                  Expanded(
                                    flex: 2,
                                    child: Material(
                                      elevation: 2,
                                      child: Container(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Image.asset('assets/images/bar_code.jpg')
                                ]),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              formatter.format(ticketDate),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.people),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              quantity.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.monetization_on),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              ticketPrice.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.call),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              phoneNb,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                              ),
                            ]),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            CustomPaint(
              painter: SideCutsDesign(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
            CustomPaint(
              painter: DottedInitialPath(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
            CustomPaint(
              painter: DottedMiddlePath(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
              ),
            ),
          ]),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }
}

class DottedMiddlePath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(size.width / 5, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DottedInitialPath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(0, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SideCutsDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h / 2), radius: 15),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w, h / 2), radius: 18),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, h), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, 0), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: const Offset(0, 0), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
