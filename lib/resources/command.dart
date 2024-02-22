import 'dart:collection';

import 'package:timeline/resources/firebase_methods.dart';

abstract interface class EventCommand {
  void execute(String eventId);
  String getTitle();
}

class LikeEventCommand implements EventCommand{
  final FirebaseMethods _firebaseMethods = FirebaseMethods.instance;

  @override
  void execute(String eventId) {
    _firebaseMethods.likeEvent(
      eventId: eventId,
      useruid: _firebaseMethods.auth.currentUser!.uid,
    );
  }

  @override
  String getTitle() {
    return "LikeEventCommand";
  }

}

class DislikeEventCommand implements EventCommand{
  final FirebaseMethods _firebaseMethods = FirebaseMethods.instance;

  @override
  void execute(String eventId) {
    // TODO: implement execute
  }

  @override
  String getTitle() {
    return "DislikeEventCommand";
  }

}

class EventCommandHistory {
  final _commandList = ListQueue<EventCommand>();

  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList =>
      _commandList.map((c) => c.getTitle()).toList();

  void add(EventCommand command) => _commandList.add(command);
}