import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:timeline/global_variables.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/screens/add_screen.dart';
import 'package:timeline/widgets/event.dart';
import 'package:timeline/widgets/event_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool add = false;
  String selectedDate = DateTime.now().toString().split(" ")[0];
  Map<String, List<Event>> _events = {};

  Future<void> fetchEvents() async {
    var snapshots = await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("events")
        .orderBy("time")
        .get();
    for (var doc in snapshots.docs) {
      String eventDate = doc["date"].split(" ")[0];
      if (_events[eventDate] == null) {
        setState(() {
          _events[eventDate] = [];
          _events[eventDate]!.add(
            Event(
              type: doc["group"],
              time: doc["time"],
              eventName: doc["event"],
              date: doc["date"],
              host: doc["creator"],
              participants: doc["participants"],
              photo: doc["ppURL"],
            ),
          );
        });
      } else {
        setState(() {
          _events[eventDate]!.add(
            Event(
              type: doc["group"],
              time: doc["time"],
              eventName: doc["event"],
              date: doc["date"],
              host: doc["creator"],
              participants: doc["participants"],
              photo: doc["ppURL"],
            ),
          );
        });
      }
    }
  }

  List<Event> _getEventsForDay(String date) {
    String data = date.split(" ")[0];
    return _events[data] ?? [];
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  FirebaseMethods firebase = FirebaseMethods.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Color.fromARGB(255, 27, 10, 81),
              // Color.fromARGB(255, 54, 23, 146),
              // Color.fromARGB(255, 203, 123, 3),
              // Color.fromARGB(255, 54, 23, 146),
              deepBlue,
              Colors.lightBlueAccent
            ],
          ),
        ),
        child: Column(
          children: [
            TimelineCalendar(
              calendarType: CalendarType.GREGORIAN,
              calendarLanguage: "en",
              calendarOptions: CalendarOptions(
                viewType: ViewType.DAILY,
                headerMonthBackColor: Colors.transparent,
                headerMonthShadowColor: Colors.transparent,
                bottomSheetBackColor: Colors.transparent,
              ),
              dayOptions: DayOptions(
                weekDaySelectedColor: Colors.black,
                selectedTextColor: Colors.white,
                selectedBackgroundColor: deepBlue,
              ),
              headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
                monthStringType: MonthStringTypes.SHORT,
                backgroundColor: Colors.transparent,
                navigationColor: Colors.white,
                // const Color.fromARGB(255, 203, 123, 3),
                headerTextColor: Colors.white,
                //const Color.fromARGB(255, 203, 123, 3),
                resetDateColor: Colors.white,
                //const Color.fromARGB(255, 203, 123, 3)
              ),
              onChangeDateTime: (datetime) {
                setState(() {
                  selectedDate = datetime.getDate();
                });
                // ignore: avoid_print
                print(selectedDate);
              },
            ),
            add == false
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _getEventsForDay(selectedDate).length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => EventInfo().showEventInfoPopup(
                            context,
                            _getEventsForDay(selectedDate)[index],
                            _getEventsForDay(selectedDate)[index].host,
                            _getEventsForDay(selectedDate)[index].participants,
                            _getEventsForDay(selectedDate)[index].photo,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: BoxDecoration(
                                        color: deepBlue,
                                        // const Color.fromARGB(255, 203, 123, 3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _getEventsForDay(selectedDate)[index]
                                              .eventName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _getEventsForDay(selectedDate)[index]
                                              .date
                                              .split(" ")[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      _getEventsForDay(selectedDate)[index]
                                          .time,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _getEventsForDay(selectedDate)[index]
                                          .type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: AddScreen(
                      onSubmit: () {
                        setState(() {
                          add = false;
                        });
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            add == false ? add = true : add = false;
          });
        },
        backgroundColor: deepBlue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(17),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
