import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class WarRoomEndpoint extends Endpoint {
  /// Realtime WebSockets stream: Emits timeline events, live chat notes,
  /// and status changes for an active incident War Room.
  Stream<IncidentEvent> streamWarRoom(Session session, int incidentId) async* {
    final channelName = 'incident_$incidentId';
    final messageStream = session.messages.createStream<IncidentEvent>(channelName);

    // Yield initial history
    final history = await IncidentEvent.db.find(
      session,
      where: (t) => t.incidentId.equals(incidentId),
      orderBy: (t) => t.createdAt,
      limit: 100,
    );
    for (final event in history) {
      yield event;
    }

    // Stream live incoming events from message bus
    await for (final event in messageStream) {
      yield event;
    }
  }

  /// Posts a note, diagnostic message, or chat entry into the War Room
  Future<IncidentEvent> postWarRoomNote(
    Session session, {
    required int incidentId,
    required String author,
    required String content,
    String eventType = 'note',
  }) async {
    final now = DateTime.now();
    final event = IncidentEvent(
      incidentId: incidentId,
      author: author,
      eventType: eventType,
      content: content,
      createdAt: now,
    );

    final saved = await IncidentEvent.db.insertRow(session, event);

    // Publish to all connected WebSockets viewers in this war room
    session.messages.postMessage(
      'incident_$incidentId',
      saved,
    );

    return saved;
  }
}
