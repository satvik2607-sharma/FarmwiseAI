import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:farmwise_ai_satvik_sharma_20bce10196/screen_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobPicker = TextEditingController();
  TextEditingController farmlandArea = TextEditingController();
  final List<String> genderItems = ['Male', 'Female', 'Others'];
  String? selectedValue;
  late String latitude;
  late String Longitude;

  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location service is disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permission denied forever');
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
      latitude = currentPosition.latitude.toString();
      Longitude = currentPosition.longitude.toString();
    });
  }

  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Details',
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PanelTitle(title: 'Name', isRequired: true),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              const PanelTitle(title: 'Address', isRequired: false),
              const TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),
              const PanelTitle(title: 'Date of Birth', isRequired: true),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: dobPicker,
                decoration: const InputDecoration(
                    // labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
                onTap: () {
                  _selectDate();
                },
              ),
              const PanelTitle(title: 'Gender', isRequired: true),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                hint: Text(
                  'Select Gender',
                  style: GoogleFonts.aBeeZee(fontSize: 14),
                ),
                items: genderItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: GoogleFonts.aBeeZee(fontSize: 14),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select Gender';
                  }
                  return null;
                },
                menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16)),
                buttonStyleData:
                    const ButtonStyleData(padding: EdgeInsets.only(right: 8)),
                onSaved: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
              const PanelTitle(
                  title: 'Farm Land Area in Acres', isRequired: true),
              TextField(
                controller: farmlandArea,
                keyboardType: TextInputType.number,
                maxLength: 100,
              ),
              const PanelTitle(
                  title: 'Latitute and Longitude', isRequired: true),
              TextButton(
                onPressed: () {
                  getCurrentLocation();
                },
                child: const Text('Get Location'),
                style: ButtonStyle(alignment: Alignment.center),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(
                  position == null ? 'Latitude' : 'latitude: ' + latitude,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  position == null ? 'longitude' : 'longitude: ' + Longitude,
                  style: TextStyle(fontSize: 15),
                ),
              ]),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondScreen(
                                    nameController.text.toString(),
                                    addressController.text.toString(),
                                    dobPicker.text.toString(),
                                    farmlandArea.text.toString(),
                                  )));
                    },
                    child: const Text('Second Screen')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (_picked != null) {
      setState(() {
        dobPicker.text = _picked.toString().split(" ")[0];
      });
    }
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  const PanelTitle({super.key, required this.title, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 2),
      child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(text: title, style: GoogleFonts.poppins(fontSize: 20)),
        TextSpan(
            text: isRequired ? "*" : " ",
            style: GoogleFonts.poppins(fontSize: 15))
      ])),
    );
  }
}
