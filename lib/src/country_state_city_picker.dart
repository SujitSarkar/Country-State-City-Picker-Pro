import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './model/city_model.dart';
import './model/country_model.dart';
import './model/state_model.dart';

class CountryStateCityPicker extends StatefulWidget {
  final TextEditingController country;
  final TextEditingController state;
  final TextEditingController city;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;

  const CountryStateCityPicker({
    super.key,
    required this.country,
    required this.state,
    required this.city,
    this.textFieldDecoration,
    this.dialogColor,
  });

  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  List<CountryModel> _countryList = [];
  final List<StateModel> _stateList = [];
  final List<CityModel> _cityList = [];

  List<CountryModel> _countrySubList = [];
  List<StateModel> _stateSubList = [];
  List<CityModel> _citySubList = [];
  String _title = '';

  @override
  void initState() {
    super.initState();

    // Set default country to India on initialization
    widget.country.text = "India";
    _getCountry(); // Load the countries list

    // Auto-load states for India by passing the India ID (assuming it's in your data)
    _getState(
        "101"); // Assuming '101' is the ID for India, replace with actual ID if needed
  }

  Future<void> _getCountry() async {
    _countryList.clear();
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList =
          body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList = _countryList;
    });
  }

  Future<void> _getState(String countryId) async {
    _stateList.clear();
    _cityList.clear();
    List<StateModel> subStateList = [];
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/state.json');
    List<dynamic> body = json.decode(jsonString);

    subStateList =
        body.map((dynamic item) => StateModel.fromJson(item)).toList();
    for (var element in subStateList) {
      if (element.countryId == countryId) {
        setState(() {
          _stateList.add(element);
        });
      }
    }
    _stateSubList = _stateList;
  }

  Future<void> _getCity(String stateId) async {
    _cityList.clear();
    List<CityModel> subCityList = [];
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/city.json');
    List<dynamic> body = json.decode(jsonString);

    subCityList = body.map((dynamic item) => CityModel.fromJson(item)).toList();
    for (var element in subCityList) {
      if (element.stateId == stateId) {
        setState(() {
          _cityList.add(element);
        });
      }
    }
    _citySubList = _cityList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Country TextField (Hidden)
        // TextField(
        //   controller: widget.country,
        //   onTap: () {
        //     // Optionally allow user to change country
        //     // _showDialog(context); // If you want to keep this.
        //   },
        //   decoration: widget.textFieldDecoration == null
        //       ? defaultDecoration.copyWith(hintText: 'Select country')
        //       : widget.textFieldDecoration
        //           ?.copyWith(hintText: 'Select country'),
        //   readOnly: true, // Hide it from the UI but it's still functional
        //   enabled: false, // Country is fixed to India
        // ),

        ///State TextField with custom label
        TextField(
          controller: widget.state,
          onTap: () {
            setState(() => _title = 'State');
            if (widget.country.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar('Select Country');
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(
                  hintText: 'Select state', labelText: 'State') // Added label
              : widget.textFieldDecoration?.copyWith(
                  hintText: 'Select state', labelText: 'State'), // Added label
          readOnly: true,
        ),
        const SizedBox(height: 20.0),

        ///City TextField with custom label
        TextField(
          controller: widget.city,
          onTap: () {
            setState(() => _title = 'City');
            if (widget.state.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar('Select State');
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(
                  hintText: 'Select city', labelText: 'City') // Added label
              : widget.textFieldDecoration?.copyWith(
                  hintText: 'Select city', labelText: 'City'), // Added label
          readOnly: true,
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();

    showGeneralDialog(
      barrierLabel: _title,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * .7,
                  margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: widget.dialogColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(_title,
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),

                      ///Text Field for Searching
                      TextField(
                        controller: _title == 'Country'
                            ? controller
                            : _title == 'State'
                                ? controller2
                                : controller3,
                        onChanged: (val) {
                          setState(() {
                            if (_title == 'Country') {
                              _countrySubList = _countryList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller.text.toLowerCase()))
                                  .toList();
                            } else if (_title == 'State') {
                              _stateSubList = _stateList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller2.text.toLowerCase()))
                                  .toList();
                            } else if (_title == 'City') {
                              _citySubList = _cityList
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(controller3.text.toLowerCase()))
                                  .toList();
                            }
                          });
                        },
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16.0),
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Search here...",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            isDense: true,
                            prefixIcon: Icon(Icons.search)),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          itemCount: _title == 'Country'
                              ? _countrySubList.length
                              : _title == 'State'
                                  ? _stateSubList.length
                                  : _citySubList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  if (_title == "Country") {
                                    widget.country.text =
                                        _countrySubList[index].name;
                                    _getState(_countrySubList[index].id);
                                    _countrySubList = _countryList;
                                    widget.state.clear();
                                    widget.city.clear();
                                  } else if (_title == 'State') {
                                    widget.state.text =
                                        _stateSubList[index].name;
                                    _getCity(_stateSubList[index].id);
                                    _stateSubList = _stateList;
                                    widget.city.clear();
                                  } else if (_title == 'City') {
                                    widget.city.text = _citySubList[index].name;
                                    _citySubList = _cityList;
                                  }
                                });
                                controller.clear();
                                controller2.clear();
                                controller3.clear();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0, right: 10.0),
                                child: Text(
                                    _title == 'Country'
                                        ? _countrySubList[index].name
                                        : _title == 'State'
                                            ? _stateSubList[index].name
                                            : _citySubList[index].name,
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 16.0)),
                              ),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                        onPressed: () {
                          if (_title == 'City' && _citySubList.isEmpty) {
                            widget.city.text = controller3.text;
                          }
                          _countrySubList = _countryList;
                          _stateSubList = _stateList;
                          _citySubList = _cityList;

                          controller.clear();
                          controller2.clear();
                          controller3.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  void _showSnackBar(String message) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 10), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.dangerous,
                size: 40,
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Please select a State',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration defaultDecoration = const InputDecoration(
      isDense: true,
      hintText: 'Select',
      suffixIcon: Icon(Icons.arrow_drop_down),
      border: OutlineInputBorder());
}
