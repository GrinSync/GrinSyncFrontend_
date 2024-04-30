import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/get_events.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/user_authorization.dart';
import 'package:flutter_test_app/global.dart';

// HomePage shows user a list of events

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier upcomingEvents = ValueNotifier<List<Event>?>(null); // A list of upcoming events as a ValueNotifier
  List<String> availableTags = ALLTAGS; // get all tags from the global variable
  List<String> selectedTags = PREFERREDTAGS; // get the preferred tags from the global variable
  bool stduentOnly = false; // show only studentOnly events
  bool intersectionFilter = false; // show events that have all selected tags

  Future<void> loadEvents() async {
    upcomingEvents.value = await getUpcomingEvents(selectedTags, stduentOnly, intersectionFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => Container(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 5.0, 
                          runSpacing: 5.0,
                          children: availableTags.map((tag) {
                            return FilterChip(
                              label: Text(tag),
                              selected: selectedTags.contains(tag),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedTags.add(tag);
                                  } else {
                                    selectedTags.remove(tag);
                                  }
                                });
                              },
                              );
                          }).toList(),
                          ),
                          if (isLoggedIn() && USER.value?.type == "STU") // show the studentOnly filter only if the user is logged in and is a student
                            CheckboxListTile(
                              title: Text('Show student only events'),
                              value: stduentOnly,
                              onChanged: (value) {
                                setState(() {
                                  stduentOnly = value!;
                                });
                              },
                            ),
                          CheckboxListTile(
                            title: Text('Match all tags'),
                            value: intersectionFilter, 
                            onChanged: (value) {
                              setState(() {
                                intersectionFilter = value!;
                              });
                            },
                            ),
                        Row(
                          children: [
                            ElevatedButton(
                              child: Text('Revert to preferred tags'),
                              onPressed: () {
                                setState(() {
                                  selectedTags = List<String>.from(PREFERREDTAGS);
                                });
                              },
                              ),
                              SizedBox(width: 10.0),  
                            ElevatedButton(
                              child: Text('Apply Filters'),
                              onPressed: () {
                                loadEvents();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                      ],
                      ),
                  )
                  )
                )
              ),
            )
        ]
      ), 
      // Original home page starting from here (tag menu added above)
      body: FutureBuilder(
          future: loadEvents(),
          builder: (context, snapshot) {
            // if the connection is waiting, show a loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    const Text('Preparing events for you...'),
                  ],
                ),
              );
              // if there is an error, show an error message and a button to try again
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading events'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          loadEvents();
                        });
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
              // if the connection is done, show the events
            } else {
              return ValueListenableBuilder(
                  valueListenable:
                      upcomingEvents, // Listens to the upcomingEvents ValueNotifier to rebuild the page when the events are (re)loaded
                  builder: (context, eventList, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RefreshIndicator(
                        onRefresh: loadEvents,
                        child: ListView.builder(
                          itemCount: eventList!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == eventList.length) {
                              return Column(
                                children: [
                                  Divider(color: Colors.grey[400]),
                                  Text('--End of All Events--',
                                      style: TextStyle(color: Colors.grey[600])),
                                  Text('Event Count: ${eventList.length}',
                                      style: TextStyle(color: Colors.grey[600])),
                                ],
                              );
                            } else {
                              return isLoggedIn() // return different event cards based on user's login status
                                  ? EventCardFavoritable(event: eventList[index])
                                  : EventCardPlain(event: eventList[index]);
                            }
                          },
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
