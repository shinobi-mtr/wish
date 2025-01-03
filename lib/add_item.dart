import 'package:flutter/material.dart';
import 'package:wish/db.dart';

const color1 = Color(0xff232426);
const color2 = Color(0xff36373A);

// Define a custom Form widget.
class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key, required this.board});

  final int board;

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _board = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _media = TextEditingController();
  final _location = TextEditingController();

  @override
  void dispose() {
    _board.dispose();
    _title.dispose();
    _description.dispose();
    _media.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color2,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: color1,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "title".toUpperCase(),
                style: TextStyle(
                    color: Colors.white, letterSpacing: 12, fontSize: 12),
              ),
              TextFormField(
                controller: _title,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text(
                "description".toUpperCase(),
                style: TextStyle(
                    color: Colors.white, letterSpacing: 12, fontSize: 12),
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text(
                "location".toUpperCase(),
                style: TextStyle(
                    color: Colors.white, letterSpacing: 12, fontSize: 12),
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _location,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text(
                "media".toUpperCase(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white, letterSpacing: 12, fontSize: 12),
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _media,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final i = Item(
                      id: 0,
                      title: _title.text,
                      description: _description.text,
                      location: _location.text,
                      media: _media.text,
                      isDone: false,
                      board: widget.board,
                    );

                    await db.insertItem(i);

                    // send http request to the server

                    Navigator.of(context).pop(i);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
