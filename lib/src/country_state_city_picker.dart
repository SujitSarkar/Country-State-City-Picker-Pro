import 'dart:convert';
import 'package:country_state_city_pro/src/model/dialog_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import './model/city_model.dart';
import './model/country_model.dart';
import './model/state_model.dart';
import 'model/field_hint_text.dart';

class CountryStateCityPicker extends StatefulWidget {
  final ValueChanged<CountryModel>? onCountryChanged;
  final ValueChanged<StateModel>? onStateChanged;
  final ValueChanged<CityModel>? onCityChanged;
  final TextEditingController country;
  final TextEditingController state;
  final TextEditingController city;
  final String? locale;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;
  final double? spacing;
  final TextStyle? inputStyle;
  final FieldHintText? fieldHintText;
  final DialogTitle? dialogTitle;
  final String? validateCountrySnackBarMessage;
  final String? validateStateSnackBarMessage;
  final String? closeTextButton;
  final ButtonStyle? closeButtonStyle;
  final String? inputSearchHintText;
  final TextStyle? inputSearchTextStyle;
  final InputDecoration? inputSearchDecoration;
  final EdgeInsetsGeometry? inputSearchPadding;


  const CountryStateCityPicker(
      {super.key,
        required this.country,
        required this.state,
        required this.city,
        this.textFieldDecoration,
        this.dialogColor,
        this.spacing,
        this.fieldHintText,
        this.dialogTitle,
        this.validateCountrySnackBarMessage,
        this.validateStateSnackBarMessage,
        this.closeTextButton,
        this.closeButtonStyle, this.inputSearchHintText,
        this.inputSearchDecoration, this.inputSearchPadding,
        this.inputStyle, this.inputSearchTextStyle,
        this.locale, this.onCountryChanged,
        this.onStateChanged, this.onCityChanged
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
  String searchKey = '';
  FieldHintText defaultHintText = FieldHintText();
  DialogTitle defaultDialogTitle = DialogTitle();

  @override
  void initState() {
    _getCountry();
    super.initState();
  }

  Future<void> _getCountry() async {

    _countryList.clear();
    var jsonString = await rootBundle
        .loadString('packages/country_state_city_pro/assets/${widget.locale ?? 'en' }/country.json');
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
        .loadString('packages/country_state_city_pro/assets/en/state.json');
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
        .loadString('packages/country_state_city_pro/assets/en/city.json');
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
        ///Country TextField
        TextField(
          controller: widget.country,
          style: widget.inputStyle,
          onTap: () {
            setState(() {
              searchKey = 'Country';
              _title = widget.dialogTitle != null
                  ? widget.dialogTitle!.countryDialogTitle
                  : defaultDialogTitle.countryDialogTitle;
            });
            _showDialog(context);
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.countryHintText
              : defaultHintText.countryHintText)
              : widget.textFieldDecoration
              ?.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.countryHintText
              : defaultHintText.countryHintText),
          readOnly: true,
        ),
        SizedBox(height: widget.spacing?? 10.0),

        ///State TextField
        TextField(
          controller: widget.state,
          style: widget.inputStyle,
          onTap: () {
            setState(() {
              searchKey = 'State';
              _title = widget.dialogTitle != null
                  ? widget.dialogTitle!.stateDialogTitle
                  : defaultDialogTitle.stateDialogTitle;
            });
            if (widget.country.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar(widget.validateCountrySnackBarMessage ?? 'Select Country');
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.stateHintText
              : defaultHintText.stateHintText)
              : widget.textFieldDecoration?.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.stateHintText
              : defaultHintText.stateHintText),
          readOnly: true,
        ),
        SizedBox(height: widget.spacing?? 10.0),

        ///City TextField
        TextField(
          controller: widget.city,
          style: widget.inputStyle,
          onTap: () {
            setState(() {
              searchKey = 'City';
              _title = widget.dialogTitle != null
                  ? widget.dialogTitle!.cityDialogTitle
                  : defaultDialogTitle.cityDialogTitle;
            });
            if (widget.state.text.isNotEmpty) {
              _showDialog(context);
            } else {
              _showSnackBar(widget.validateStateSnackBarMessage ?? 'Select State');
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.cityHintText
              : defaultHintText.cityHintText)
              : widget.textFieldDecoration?.copyWith(hintText: widget.fieldHintText != null
              ? widget.fieldHintText!.cityHintText
              : defaultHintText.cityHintText),
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

                      ///Text Field
                      Padding(
                        padding: widget.inputSearchPadding ??  EdgeInsets.all(.0),
                        child: TextField(
                          controller: searchKey == 'Country'
                              ? controller
                              : searchKey == 'State'
                              ? controller2
                              : controller3,
                          onChanged: (val) {
                            setState(() {
                              if (searchKey == 'Country') {
                                _countrySubList = _countryList
                                    .where((element) => element.name
                                    .toLowerCase()
                                    .contains(controller.text.toLowerCase()))
                                    .toList();
                              } else if (searchKey == 'State') {
                                _stateSubList = _stateList
                                    .where((element) => element.name
                                    .toLowerCase()
                                    .contains(controller2.text.toLowerCase()))
                                    .toList();
                              } else if (searchKey == 'City') {
                                _citySubList = _cityList
                                    .where((element) => element.name
                                    .toLowerCase()
                                    .contains(controller3.text.toLowerCase()))
                                    .toList();
                              }
                            });
                          },
                          style: widget.inputSearchTextStyle ??  TextStyle(
                              color: Colors.grey.shade800, fontSize: 15.0),
                          decoration: widget.inputSearchDecoration ?? InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: widget.inputSearchHintText ?? "Search here...",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 5),
                              isDense: true,
                              prefixIcon: Icon(Icons.search)),
                        ),
                      ),

                      ///Dropdown Items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          itemCount: searchKey == 'Country'
                              ? _countrySubList.length
                              : searchKey == 'State'
                              ? _stateSubList.length
                              : _citySubList.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  if (searchKey == "Country") {
                                    widget.country.text = _countrySubList[index].name;
                                    if(widget.onCountryChanged != null){
                                      widget.onCountryChanged!(_countrySubList[index]);
                                    }
                                    _getState(_countrySubList[index].id);
                                    _countrySubList = _countryList;
                                    widget.state.clear();
                                    widget.city.clear();
                                  } else if (searchKey == 'State') {
                                    widget.state.text = _stateSubList[index].name;
                                    if(widget.onStateChanged != null){
                                      widget.onStateChanged!(_stateSubList[index]);
                                    }
                                    _getCity(_stateSubList[index].id);
                                    _stateSubList = _stateList;
                                    widget.city.clear();
                                  } else if (searchKey == 'City') {
                                    widget.city.text = _citySubList[index].name;
                                    if(widget.onCityChanged != null){
                                      widget.onCityChanged!(_citySubList[index]);
                                    }
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
                                    searchKey == 'Country'
                                        ? _countrySubList[index].name
                                        : searchKey == 'State'
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
                        style: widget.closeButtonStyle ??
                            OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                        onPressed: () {
                          if (searchKey == 'City' && _citySubList.isEmpty) {
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
                        child: Text(widget.closeTextButton ?? 'Close'),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16.0))));
  }

  InputDecoration defaultDecoration = const InputDecoration(
      isDense: true,
      hintText: 'Select',
      suffixIcon: Icon(Icons.arrow_drop_down),
      border: OutlineInputBorder());
}
