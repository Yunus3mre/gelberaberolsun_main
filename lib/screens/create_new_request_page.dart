import 'package:flutter/material.dart';
import 'package:gelberaberolsun/screens/sign_up_page.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({Key key}) : super(key: key);

  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  String dateRange = "";
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController sehirController = new TextEditingController();
  TextEditingController ilceController = new TextEditingController();
  TextEditingController bilgiController = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
   


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("İstek Oluştur"),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTextFormField(
                    controller: sehirController,
                    prefixIcon: Icon(Icons.location_city),
                    hintText: "Şehir",
                  ),
                  SizedBox(height: 15),
                  MyTextFormField(
                    controller: ilceController,
                    prefixIcon: Icon(Icons.location_on),
                    hintText: "İlçe",
                  ),
                  SizedBox(height: 15),
                  MyTextFormField(
                    controller: dateController,
                    prefixIcon: Icon(Icons.date_range),
                    hintText: "Tarih",
                    onTap: () async {
                      DateTime dateTimeRange = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2022));
                      String date =
                          "${dateTimeRange.year}-${dateTimeRange.month}-${dateTimeRange.day}";
                      dateController.text = date;
                    },
                  ),
                  SizedBox(height: 15),
                  MyTextFormField(
                    controller: timeController,
                    prefixIcon: Icon(Icons.timelapse),
                    hintText: "Saat",
                    onTap: () async {
                      //TimeOfDay time=await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      //timeController.text="${time.hour}:${time.minute}";
                      TimeRange result =
                          await showTimeRangePicker(context: context);
                      //print(result.startTime.);
                      String time =
                          "${result.startTime.hour}:${result.startTime.minute}-${result.endTime.hour}:${result.endTime.minute}";
                      timeController.text = time;
                    },
                  ),
                  SizedBox(height: 15),
                  MyTextFormField(
                    limit: 80,
                    hintText: "Ek Bilgi",
                    controller: bilgiController,
                    prefixIcon: Icon(Icons.info),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      var map = {
                        "isim": Provider.of<Auth>(context, listen: false)
                            .getCurrentUserName(),
                        "sehir": sehirController.text,
                        "ilce": ilceController.text,
                        "tarih": dateController.text,
                        "saat": timeController.text,
                        "bilgi": bilgiController.text,
                        "uid": Provider.of<Auth>(context, listen: false)
                            .getCurrentUser()
                            .uid,
                        "olusturma tarihi": DateTime.now(),
                      };

                      if (formKey.currentState.validate()) {
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .createRequest(map);
                          Navigator.pop(context);
                        } catch (e) {
                          
                          print("hata:" + e);
                          
                        }
                      }
                    },
                    child: Text("Oluştur"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 50),
                      primary: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final Icon prefixIcon;
  final String hintText;
  final Function onTap;
  final TextEditingController controller;
  final limit;

  MyTextFormField(
      {this.hintText, this.prefixIcon, this.onTap, this.controller,this.limit});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
     maxLength: limit,
      validator: (value) {
        if (value.isEmpty) {
          return "Bu Alan Boş Bırakılamaz.";
        } else {
          return null;
        }
      },
      controller: controller,
      maxLines: 2,
      minLines: 1,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
