import 'package:flutter/material.dart';
import 'package:wish/db.dart';

const color1 = Color(0xff232426);
const color2 = Color(0xff36373A);

class BoardCard extends StatelessWidget {
  final int id;
  final String title;
  final String file;

  const BoardCard({
    super.key,
    required this.id,
    required this.title,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(Board(id: id, title: title, file: file)),
      child: Card(
        color: color2,
        // color: Colors.redAccent,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 12, fontSize: 18),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddBoardForm extends StatefulWidget {
  const AddBoardForm({super.key});

  @override
  State<AddBoardForm> createState() => _AddBoardFormState();
}

class _AddBoardFormState extends State<AddBoardForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();

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
            children: [
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _title,
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
                    final data =
                        Board(id: 0, title: _title.text, file: "this is a test");
                    await db.insertBoard(data);
                    Navigator.of(context).pop(data);
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late Future<List<Board>> boards;

  @override
  void initState() {
    super.initState();
    boards = db.listBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: color2,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const AddBoardForm(),
                  ),
                )
                    .then((val) {
                      
                  if(val == null) return;
                  add() async {
                    final l = await boards;
                    l.add(val);
                    return l;
                  }

                  setState(() {
                    boards = add();
                  });
                });
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        backgroundColor: color1,
        body: FutureBuilder(
            future: boards,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("loading");
              } else if (snapshot.hasError) {
                return Text("error loading the data");
              } else {
                final List<Widget> l = [];

                for (final b in snapshot.data!) {
                  l.add(BoardCard(id: b.id, title: b.title, file: b.file));
                }

                return ListView(
                  children: l,
                );
              }
            }));
  }
}
