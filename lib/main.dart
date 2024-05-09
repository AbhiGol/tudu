import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
//import 'package:tudu/database.dart';
import 'package:tudu/home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
  databaseFactory = databaseFactoryFfiWeb;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}

/*class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<Map<String, dynamic>> _list = [];

  List _list = <String>[];
  bool empty = true;

  void _refreshList() async {
    final data = await SQLHelper.getItems();

    setState(() {
      _list = data;
      empty = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingList = _list.firstWhere((element) => element['id'] == id);
      _titleController.text = existingList['title'];
      _descriptionController.text = existingList['description'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => (Container(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                }

                if (id != null) {
                  await _updateItem(id);
                }

                _titleController.text = '';
                _descriptionController.text = '';

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      )),
    );
  }

// Insert
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshList();
  }

  // Update
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshList();
  }

  // Delete
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu,
            size: 29, color: Color.fromARGB(255, 81, 117, 208)),
        actions: const <Widget>[
          Text(
            "Tudu",
            style: TextStyle(
                fontSize: 28,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
      body: empty
          ? Container(
              alignment: Alignment.center,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Add a task to get started",
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(13),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.circle,
                          size: 14,
                        ),
                        title: Text(_list[index]['title']),
                        subtitle: Text(_list[index]['description']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.green),
                                onPressed: () => _showForm(_list[index]['id']),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _deleteItem(_list[index]['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 81, 117, 208),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _showForm(null),
      ),
    );
  }
}

final responceProvider = StateProvider((ref) => SQLHelper.getItems());
*/