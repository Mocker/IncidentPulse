import 'dart:async';
import 'package:flutter/material.dart';
import 'package:incident_pulse_client/incident_pulse_client.dart';
import '../../core/client.dart';
import '../../core/theme.dart';

class WarRoomScreen extends StatefulWidget {
  final Incident incident;
  final String serviceName;

  const WarRoomScreen({
    super.key,
    required this.incident,
    this.serviceName = '',
  });

  @override
  State<WarRoomScreen> createState() => _WarRoomScreenState();
}

class _WarRoomScreenState extends State<WarRoomScreen> {
  final TextEditingController _noteController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Incident _incident;
  final List<IncidentEvent> _timelineEvents = [];
  StreamSubscription<IncidentEvent>? _subscription;
  bool _streamError = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _incident = widget.incident;
    _subscribe();
  }

  void _subscribe() {
    _subscription = client.warRoom.streamWarRoom(_incident.id!).listen(
      (event) {
        if (!mounted) return;
        setState(() => _timelineEvents.add(event));
        _scrollToBottom();
      },
      onError: (e) {
        if (!mounted) return;
        setState(() => _streamError = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('War room stream interrupted: $e')),
        );
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _streamError = true);
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _noteController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime t) {
    final local = t.toLocal();
    final h = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final m = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isResolved = _incident.status == 'resolved';
    final canAcknowledge = _incident.status == 'triggered';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: isResolved
                      ? IncidentTheme.statusOperational
                      : IncidentTheme.statusCritical,
                  size: 10,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'War Room: Incident #${_incident.id}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              '${widget.serviceName} • ${_incident.severity.toUpperCase()} • ${_incident.status.toUpperCase()}'
              '${_streamError ? ' • stream reconnecting…' : ' • WebSockets Streaming Active'}',
              style: const TextStyle(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          if (canAcknowledge)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF60A5FA),
                side: const BorderSide(color: Color(0xFF60A5FA)),
              ),
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: const Text('Acknowledge'),
              onPressed: _acknowledgeIncident,
            ),
          if (!isResolved) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: IncidentTheme.statusOperational,
                side: const BorderSide(color: IncidentTheme.statusOperational),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: const Text('Resolve'),
              onPressed: _showResolveDialog,
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
      body: Column(
        children: [
          // Incident summary header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: IncidentTheme.surface,
              border: Border(
                  bottom: BorderSide(color: IncidentTheme.surfaceBorder)),
            ),
            child: Text(
              _incident.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),

          // Timeline Stream
          Expanded(
            child: _timelineEvents.isEmpty && !_streamError
                ? const Center(
                    child: Text(
                      'Waiting for war room events…',
                      style:
                          TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: _timelineEvents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) =>
                        _buildEventTile(_timelineEvents[index]),
                  ),
          ),

          // Message & Note Ingress Input
          if (!isResolved)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: IncidentTheme.surface,
                border: Border(
                    top: BorderSide(
                        color: IncidentTheme.surfaceBorder, width: 1)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        enabled: !_sending,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText:
                              'Post a note or diagnostic command to the War Room…',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendNote(),
                      ),
                    ),
                    _sending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: IncidentTheme.aiAccent,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send_rounded,
                                color: IncidentTheme.aiAccent),
                            onPressed: _sendNote,
                          ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventTile(IncidentEvent event) {
    final isAi = event.eventType == 'ai_insight';
    final isAlert =
        event.eventType == 'alert' || event.eventType == 'status_change';

    Color authorColor = Colors.white70;
    IconData icon = Icons.chat_bubble_outline;
    if (isAi) {
      authorColor = IncidentTheme.aiAccent;
      icon = Icons.auto_awesome;
    } else if (isAlert) {
      authorColor = IncidentTheme.statusCritical;
      icon = Icons.warning_amber_rounded;
    }

    return Card(
      color: isAi ? const Color(0xFF1E1730) : IncidentTheme.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isAi
              ? IncidentTheme.aiAccent.withValues(alpha: 0.4)
              : IncidentTheme.surfaceBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: authorColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.author,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: authorColor,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(event.createdAt),
                  style:
                      const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              event.content,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13.5, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      // The server persists the note and broadcasts it back over the
      // live stream, so it appears in the timeline without local echo.
      await client.warRoom.postWarRoomNote(
        incidentId: _incident.id!,
        author: 'On-Call Engineer',
        content: text,
        eventType: 'note',
      );
      _noteController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post note: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _acknowledgeIncident() async {
    try {
      final updated = await client.incident.acknowledgeIncident(
        incidentId: _incident.id!,
        responderName: 'On-Call Engineer',
      );
      if (!mounted) return;
      if (updated != null) {
        setState(() => _incident = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident acknowledged.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Acknowledge failed: $e')),
      );
    }
  }

  void _showResolveDialog() {
    final rootCauseController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: IncidentTheme.surface,
        title: const Text('Resolve Incident',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Document root cause for post-mortem & reliability analytics:',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: rootCauseController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText:
                    'e.g. Updated STRIPE_WEBHOOK_SECRET in production config.',
                hintStyle: TextStyle(color: Colors.white38),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: IncidentTheme.statusOperational),
            onPressed: () async {
              final rootCause = rootCauseController.text.trim();
              Navigator.pop(context);
              await _resolveIncident(rootCause.isEmpty
                  ? 'Resolved without documented root cause.'
                  : rootCause);
            },
            child: const Text('Confirm Resolution',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _resolveIncident(String rootCause) async {
    try {
      final updated = await client.incident.resolveIncident(
        incidentId: _incident.id!,
        resolverName: 'On-Call Engineer',
        rootCause: rootCause,
      );
      if (!mounted) return;
      if (updated != null) {
        setState(() => _incident = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident marked as Resolved.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resolve failed: $e')),
      );
    }
  }
}
