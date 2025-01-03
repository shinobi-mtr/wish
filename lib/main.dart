import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish/add_board.dart';
import 'package:wish/add_item.dart';
import 'package:wish/db.dart';

const color1 = Color(0xff232426);
const color2 = Color(0xff36373A);

class AppCard extends StatefulWidget {
  final Item item;

  const AppCard({super.key, required this.item});

  @override
  State<AppCard> createState() => _AppCard();
}

class _AppCard extends State<AppCard> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    widget.item.title.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 12, fontSize: 18),
                  ),
                  Text(
                    widget.item.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {},
                        fillColor: color1,
                        constraints: BoxConstraints(minWidth: 0.0),
                        padding: EdgeInsets.all(6.0),
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.ios_share,
                          size: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(widget.item.media);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        fillColor: color1,
                        constraints: BoxConstraints(minWidth: 0.0),
                        padding: EdgeInsets.all(6.0),
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.play_arrow,
                          size: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(widget.item.location);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        fillColor: color1,
                        constraints: BoxConstraints(minWidth: 0.0),
                        padding: EdgeInsets.all(6.0),
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.place,
                          size: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          // await db.toggleItemStatus(widget.item);
                          setState(() {
                            checked = !checked;
                          });
                        },
                        fillColor: checked ? color1 : Colors.white,
                        constraints: BoxConstraints(minWidth: 0.0),
                        padding: EdgeInsets.all(6.0),
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.done,
                          size: 16.0,
                          color: checked ? Colors.white : color1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //     width: 80,
            //     child: Stack(
            //       children: [
            //         Container(
            //           width: 40.0,
            //           height: 40.0,
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //                 color: Color.fromARGB(255, 112, 61, 62), width: 2),
            //             color: Color(0xffD28391),
            //             shape: BoxShape.circle,
            //           ),
            //         ),
            //         Positioned(
            //           left: 10.0,
            //           child: Container(
            //             width: 40.0,
            //             height: 40.0,
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                   color: Color.fromARGB(255, 67, 108, 122),
            //                   width: 2),
            //               color: Color(0xff83BDD2),
            //               shape: BoxShape.circle,
            //             ),
            //           ),
            //         ),
            //         Positioned(
            //           left: 20.0,
            //           child: Container(
            //             width: 40.0,
            //             height: 40.0,
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                   color: Color.fromARGB(255, 108, 128, 71),
            //                   width: 2),
            //               color: Color(0xffB7D283),
            //               shape: BoxShape.circle,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ))
          ],
        ),
      ),
    );
  }
}

void main() async {
  await db.init();
  runApp(const MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Item>> items;
  late Board board = Board(id: 0, file: "", title: "default");

  @override
  void initState() {
    super.initState();
    items = db.listItems(board.id, 0, 100);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            board.title.toUpperCase(),
            style:
                TextStyle(color: Colors.white, letterSpacing: 8, fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(builder: (context) => const BoardPage()),
                )
                    .then((val) {
                  if (val == null) return;
                  setState(() {
                    board = val;
                    items = db.listItems(val.id, 0, 100);
                  });
                });
              },
              icon: Icon(
                Icons.expand_more,
                color: Colors.white,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                      builder: (context) => AddItemForm(board: board.id)),
                )
                    .then((val) {
                  if (val == null) return;
                  add() async {
                    final l = await items;
                    l.add(val);
                    return l;
                  }

                  setState(() {
                    items = add();
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
          backgroundColor: color2,
        ),
        backgroundColor: color1,
        body: FutureBuilder(
          future: items,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("loading");
            } else if (snapshot.hasError) {
              return Text("error loading the data");
            } else {
              final List<Widget> l = [];

              for (final b in snapshot.data!) {
                l.add(AppCard(item: b));
              }

              return ListView(
                children: l,
              );
            }
          },
        ));
  }
}
