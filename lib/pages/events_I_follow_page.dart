import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/event_models.dart';
import 'package:flutter_test_app/api/get_events.dart';

class EventsIFollowPage extends StatefulWidget {
  EventsIFollowPage({super.key});

  @override
  State<EventsIFollowPage> createState() => _EventsIFollowPageState();
}

class _EventsIFollowPageState extends State<EventsIFollowPage> {
  late List<Event> events; // List of events followed by the user

  // Get events followed by the user from the backend
  Future<void> loadEvents() async {
    events = await getLikedEvents(); // function in get_events.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events I Follow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      // Use a FutureBuilder to wait for the events to load
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
                    const Text(
                      'Preparing events for you...',
                    ),
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
                        loadEvents();
                        setState(() {});
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
              // if the connection is done, show the events
            } else {
              // if there are no events, show a message
              if (events.isEmpty) {
                return const Center(
                  child: Text("You are not following any events yet."),
                );
                // if there are events, show the events
              } else {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: events.length + 1,
                    itemBuilder: (context, index) {
                      if (index == events.length) {
                        return Column(
                          children: [
                            Divider(color: Colors.grey[400]),
                            Text('--End of Your Saved Events--',
                                style: TextStyle(color: Colors.grey[600])),
                            Text('Event Count: ${events.length}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        );
                      } else {
                        return EventCardFavoritable(event: events[index]); // EventCardFavoritable is a custom widget that displays an event with a favorite button
                      }
                    },
                  ),
                );
              }
            }
          }),
    );
  }
}
