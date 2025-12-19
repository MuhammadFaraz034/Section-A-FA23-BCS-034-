
import 'package:flutter/material.dart';
import 'db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> notes = [];

  final titleController = TextEditingController();
  final descController = TextEditingController();

  void loadNotes() async {
    final data = await DBHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Colorful Notes")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Add Note"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                  TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await DBHelper.insertNote(titleController.text, descController.text);
                    titleController.clear();
                    descController.clear();
                    loadNotes();
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          );
        },
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (ctx, i) => Card(
          color: Colors.deepPurple.shade100,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(notes[i]['title']),
            subtitle: Text(notes[i]['description']),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DBHelper.deleteNote(notes[i]['id']);
                loadNotes();
              },
            ),
          ),
        ),
      ),
    );
  }
}
