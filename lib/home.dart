import 'package:tudu/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage1State();
}

class _HomePage1State extends ConsumerState<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) {
    if (id != null) {
      final existinglist =
          ref.watch(listProvider).firstWhere((element) => element['id'] == id);
      _titleController.text = existinglist['title'];
      _descriptionController.text = existinglist['description'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding:
            const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 30),
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
                  await SQLHelper.createItem(
                      _titleController.text, _descriptionController.text);
                  ref.read(listProvider.notifier).state =
                      await SQLHelper.getItems();
                }
                if (id != null) {
                  await SQLHelper.updateItem(
                      id, _titleController.text, _descriptionController.text);
                  ref.read(listProvider.notifier).state =
                      await SQLHelper.getItems();
                }
                _titleController.text = '';
                _descriptionController.text = '';

                Navigator.pop(context);
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //ref.read(isLoadingProvider.notifier).state = true;
    SQLHelper.getItems().then(
      (value) {
        ref.read(listProvider.notifier).state = value;
        //ref.read(isLoadingProvider.notifier).state = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(listProvider);
    final isloding = ref.watch(isLoadingProvider);

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
          ),
        ],
      ),
      body: isloding
          ? const Center(child: Text("Data not found."))
          : ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
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
                        title: Text(lists[index]['title']),
                        subtitle: Text(lists[index]['description']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.green),
                                onPressed: () => _showForm(lists[index]['id']),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  SQLHelper.deleteItem(lists[index]['id']);
                                  ref.read(listProvider.notifier).state =
                                      await SQLHelper.getItems();
                                },
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
