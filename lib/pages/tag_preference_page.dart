import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grinsync/global.dart';
import 'package:grinsync/api/tags.dart';

class TagPreferencePage extends StatefulWidget {
  @override
  _TagPreferencePageState createState() => _TagPreferencePageState();

  const TagPreferencePage({super.key});
}

class _TagPreferencePageState extends State<TagPreferencePage> {
  List<String> availableTags =
      List<String>.from(ALLTAGS); // List of all available tags
  List<String> selectedTags =
      List<String>.from(PREFERREDTAGS); // List of selected tags
  int additionalItemNumber =
      3; // Number of additional items in the listviewbuilder (title, select all, deselect all)

  @override
  Widget build(BuildContext context) {
    availableTags.sort(); // Sort the tags alphabetically

    Future<void> saveTags() async {
      // Save the selected tags to the server
      await updatePrefferedTags(selectedTags);

      // Update the selected tags locally
      PREFERREDTAGS = List<String>.from(selectedTags);

      // Show a flutter toast message
      Fluttertoast.showToast(
          msg: 'Changes saved',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tag Preferences',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: ListView.builder(
          itemCount: availableTags.length + additionalItemNumber,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Title
              return const Text('Select tags for homepage feed:',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica'));
            } else if (index == 1) {
              // Select all
              return ListTile(
                title: const Text('Select all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    selectedTags = List<String>.from(availableTags);
                    saveTags();
                    setState(() {});
                  },
                ),
              );
            } else if (index == 2) {
              // Deselect all
              return ListTile(
                title: const Text('Deselect all',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    selectedTags = [];
                    saveTags();
                    setState(() {});
                  },
                ),
              );
            } else {
              // Tags
              final tag =
                  availableTags[index - additionalItemNumber]; // Get the tag
              final isSelected =
                  selectedTags.contains(tag); // Check if the tag is selected

              return ListTile(
                title: Text(tag),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (selected) {
                    // Update the selected tags
                    if (selected!) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                      saveTags();
                    setState(() {});
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
