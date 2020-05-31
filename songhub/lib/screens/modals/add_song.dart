import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db_service.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // actions: [
        //   new FlatButton(
        //     onPressed: () {
        //     },
        //     child: Text("SAVE"),
        //   )
        // ],
      ),
      body: AddSongForm(),
      backgroundColor: Colors.white,
    );
  }
}

class _AddSongFormState extends State<AddSongForm> {
  final _db = DatabaseService();
  final _titleController = TextEditingController();
  String currentStatus = "Initiation";
  List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];

  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            AddCoverImage(),
            Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TODO: 2 Textfields
                  ],
                )),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: buildStatusField(),
          ),
          SongFormEntry(
            titleController: _titleController,
            label: "Title",
          ),
          SongFormEntry(
            titleController: _titleController,
            label: "Artist",
          ),
          AddSongButton(db: _db, titleController: _titleController),
        ],
      ),
    );
  }

  FormField<String> buildStatusField() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelStyle: textStyle,
            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            hintText: 'Please select expense',
            fillColor: Color(0xFFF2F5FA),
            filled: true,
            border: InputBorder.none,
          ),
          // OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: currentStatus == "",
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentStatus,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  currentStatus = newValue;
                  state.didChange(newValue);
                });
              },
              items: statusValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class AddCoverImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Color(0xFFF2F5FA),
        width: 125,
        height: 125,
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.black,
          onPressed: () {},
        ),
      ),
    );
  }
}

class AddSongButton extends StatelessWidget {
  final DatabaseService db;
  final TextEditingController titleController;

  const AddSongButton({
    this.db,
    this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            textColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Create",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              // db.addSongDocument(titleController.text);
            },
          )),
    );
  }
}

class SongFormEntry extends StatelessWidget {
  final TextEditingController titleController;
  final String label;

  const SongFormEntry({this.titleController, this.label});

  final bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        controller: titleController,
        decoration: InputDecoration(
          fillColor: Color(0xFFF2F5FA),
          filled: true,
          border: InputBorder.none,
          // border: OutlineInputBorder(),
          labelText: label,
          errorText: _validate ? "Value can\'t be empty!" : null,
        ),
      ),
    );
  }
}

class AddSongForm extends StatefulWidget {
  @override
  _AddSongFormState createState() {
    return _AddSongFormState();
  }
}

// class _AddSongFormState extends State<AddSongForm> {
//   final _formKey = GlobalKey<FormState>();

//   String currentStatus = "Initiation";
//   List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         children: <Widget>[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(5.0),
//                 child: Container(
//                   color: Colors.grey[200],
//                   width: 125,
//                   height: 125,
//                   alignment: Alignment.center,
//                   child: IconButton(
//                     icon: Icon(Icons.add),
//                     color: Colors.black,
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//               Padding(
//                   padding: const EdgeInsets.only(left: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[],
//                   )),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 16.0),
//           ),
//           DropdownButton<String>(
//             value: currentStatus,
//             hint: Text("Status"),
//             isExpanded: true,
//             underline: Container(
//               height: 1,
//               color: Colors.grey,
//             ),
//             onChanged: (String newValue) {
//               setState(() {
//                 currentStatus = newValue;
//               });
//             },
//             items: statusValues.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//           SongForm(formKey: _formKey),
//           AppButton(formKey: _formKey, title: "", artist: "", imageUrl: "", status: currentStatus, lyrics: "", mood: ""),
//         ],
//       ),
//     );
//   }
// }

// class SongForm extends StatelessWidget {
//   const SongForm({
//     Key key,
//     @required GlobalKey<FormState> formKey,
//   })  : _formKey = formKey,
//         super(key: key);

//   final GlobalKey<FormState> _formKey;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           GeneralTextForm(label: "Lyrics"),
//           GeneralTextForm(label: "Mood"),
//         ],
//       ),
//     );
//   }
// }

// class AppButton extends StatelessWidget {

//   final GlobalKey<FormState> formKey;
//   final String title, artist, imageUrl, status, lyrics, mood;

//   final db = DatabaseService();

//   AppButton({this.formKey, this.title, this.artist, this.imageUrl, this.status, this.lyrics, this.mood});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 16.0),
//       child: SizedBox(
//         width: double.infinity,
//         child: RaisedButton(
//           textColor: Colors.white,
//           child: Text(
//             "Create new song",
//             style: new TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//           color: Theme.of(context).accentColor,
//           onPressed: () {
//             if (formKey.currentState.validate()) {
//               var ref = db.addSongDocument(title, artist, imageUrl, status, lyrics, mood);
//               print(ref);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class GeneralTextForm extends StatelessWidget {
//   final String label;

//   const GeneralTextForm({this.label});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(labelText: label),
//       validator: (value) {
//         if (value.isEmpty) {
//           return 'Please enter some text';
//         }
//         return null;
//       },
//     );
//   }
// }
