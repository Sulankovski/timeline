import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline/resources/firebase_methods.dart';
import 'package:timeline/widgets/input_box.dart';

class AddScreen extends StatefulWidget {
  final VoidCallback onSubmit;
  const AddScreen({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final FirebaseMethods firebase = FirebaseMethods.instance;
  // ignore: prefer_final_fields
  TextEditingController _name = TextEditingController();
  String name = "";
  String location = "";
  DateTime _dateTime = DateTime.now();
  String _date = "Choose date";
  TimeOfDay _timeOfDay = TimeOfDay.now();
  String _time = "Choose time";
  // ignore: prefer_final_fields
  String _local = "";
  String locationTExt = "Choose location";
  String _selectedOption = "group";
  String _group = "";

  void picDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        _dateTime = value!;
        _date =
            "${_dateTime.day.toString()}-${_dateTime.month.toString()}-${_dateTime.year.toString()}";
      });
    });
  }

  void picTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
        _time = "${_timeOfDay.hour.toString()}-${_timeOfDay.minute.toString()}";
      });
    });
  }

  void makeEvent() async {
    String rez = await firebase.createNewEvent(
      dateTime: _dateTime,
      timeOfDay: _timeOfDay,
      name: _name.text,
      group: _group,
      location: _local,
    );
    setState(() {
      widget.onSubmit();
    });
    // ignore: avoid_print
    print(rez);
  }

  static const LatLng _startPos = LatLng(
    42.01337147247476,
    21.45954110749342,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputBox(
                controller: _name,
                hitText: "Input name for event",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextButton(
                        onPressed: picDate,
                        child: Text(
                          _date,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextButton(
                        onPressed: picTime,
                        child: Text(
                          _time,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      var geoPoints = await showSimplePickerLocation(
                        context: context,
                        isDismissible: true,
                        title: "Pick",
                        initPosition: GeoPoint(
                          latitude: _startPos.latitude,
                          longitude: _startPos.longitude,
                        ),
                      );
                      if (geoPoints != null) {
                        setState(() {
                          _local =
                              "${geoPoints.latitude} ${geoPoints.longitude}";
                          locationTExt = "Location chosen";
                        });
                        print(_local);
                      }
                    },
                    child: Text(
                      locationTExt,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  width: 77,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    icon: Container(),
                    alignment: Alignment.center,
                    value: _selectedOption,
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                        _group = newValue;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return ["public", "private", "group"]
                          .map<Widget>((String item) {
                        return Center(
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    items: ["public", "private", "group"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  child: TextButton(
                    onPressed: () => makeEvent(),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
