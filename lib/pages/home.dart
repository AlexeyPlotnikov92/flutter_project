import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test_project/entity/task.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  late DocumentSnapshot lastDocument;
  String nameTask = '';
  String timeTask = '';
  MyTask task = MyTask(name: '', time: DateTime.now(), description: '');
  List todoList = [];
  TextEditingController inputController = TextEditingController();
  TextEditingController editingDateController = TextEditingController();
  TextEditingController editingNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProducts();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
    //
    //   }
    // });

    //todoList.addAll(['abc', 'def', 'rfe', 'www']);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _scrollController.dispose();
  // }

  void _menuOpen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Menu'),
          ),
          body: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: Text('to main')),
              Padding(padding: EdgeInsets.only(left: 15)),
              Text('our simple menu'),
            ],
          ));
    }));
  }

  void listener() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
  }

  getProducts() async {
    Query q = firestore.collection('tasks').orderBy('name');
    q.get();
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('tasks')
          .orderBy('name')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('products')
          .orderBy('name')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    todoList.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('список'),
  //     ),
  //     body: Column(children: [
  //       Expanded(
  //         child:firestore.collection('tasks').snapshots().length == 0
  //             ? Center(
  //           child: Text('No Data...'),
  //         )
  //             : ListView.builder(
  //           controller: _scrollController,
  //           itemCount: todoList.length,
  //           itemBuilder: (context, index) {
  //             return ListTile(
  //               contentPadding: EdgeInsets.all(5),
  //               title: Text(todoList[index].data['name']),
  //               subtitle: Text(todoList[index].data['time']),
  //             );
  //           },
  //         ),
  //       ),
  //       isLoading
  //           ? Container(
  //         width: MediaQuery.of(context).size.width,
  //         padding: EdgeInsets.all(5),
  //         color: Colors.yellowAccent,
  //         child: Text(
  //           'Loading',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       )
  //           : Container()
  //     ]),
  //   );
  // }

  String showText(Timestamp input) {
    DateTime dateTime = input.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

  Color todoColor(String dateTime) {
    DateTime itemDate = DateTime.parse(dateTime);
    if (DateTime.now().isAfter(itemDate)) {
      return Colors.redAccent;
    }
    return Colors.greenAccent;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Список'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu_open_outlined),
            onPressed: () {
              _menuOpen();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('no data');
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(snapshot.data!.docs[index].id),
                child: Card(
                  child: ListTile(
                    tileColor: todoColor(showText(snapshot.data!.docs[index].get('time'))),
                    title: Text(snapshot.data!.docs[index].get('name') +
                        ' ' +
                        showText(snapshot.data!.docs[index].get('time'))),
                    // trailing: IconButton(
                    //   icon: Icon(
                    //     Icons.delete_sweep,
                    //     color: Colors.deepOrangeAccent,
                    //   ),
                    //   onPressed: () {
                    //     FirebaseFirestore.instance
                    //         .collection('tasks')
                    //         .doc(snapshot.data!.docs[index].id)
                    //         .delete();
                    //   },
                    // ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: Icon(
                                Icons.delete_sweep,
                                color: Colors.deepOrangeAccent,
                            )),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: TextField(
                                        controller: editingDateController..text = showText(snapshot.data!.docs[index].get('time')),
                                        decoration: InputDecoration(
                                            labelText: 'Date', icon: Icon(Icons.calendar_today)),
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2020),
                                              //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2024));
                                          if (pickedDate != null) {
                                            print(pickedDate);
                                            String formattedDate =
                                            DateFormat('yyyy-MM-dd').format(pickedDate);
                                            print(formattedDate);
                                            task.time = pickedDate;

                                            setState(() {
                                              editingDateController.text =
                                                  formattedDate;
                                            });
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },
                                      ),
                                      content: TextField(
                                        controller: editingNameController..text = snapshot.data!.docs[index].get('name'),
                                        onChanged: (String tName) {
                                            if (tName.isEmpty || tName == null) {
                                              task.name = snapshot.data!.docs[index].get('name');
                                            }
                                            else {
                                              task.name = tName;
                                            }
                                          },
                                        decoration: InputDecoration(labelText: 'Name'),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(snapshot.data!.docs[index].id)
                                                  .update({
                                                'name': task.name,
                                                'time': task.time,
                                                'desc': task.description
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('изменить'))
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                                Icons.edit,
                                color: Colors.yellowAccent,)),
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(snapshot.data!.docs[index].id)
                      .delete();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: TextField(
                    controller: inputController..text = showText(Timestamp.now()),
                    decoration: InputDecoration(
                        labelText: 'Date', icon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2024));
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);
                        task.time = pickedDate;

                        setState(() {
                          inputController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  content: TextField(
                    onChanged: (String tName) {
                      task.name = tName;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('tasks').add({
                            'name': task.name,
                            'time': task.time,
                            'desc': task.description
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('добавить'))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
