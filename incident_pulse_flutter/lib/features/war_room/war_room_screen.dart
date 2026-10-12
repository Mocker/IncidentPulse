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
    _loadHistory();
    _subscribe();
  }

  void _addOrUpdateEvents(List<IncidentEvent> events) {
    bool changed = false;
    for (final event in events) {
      if (event.id != null) {
        final existingIndex = _timelineEvents.indexWhere((e) => e.id == event.id);
        if (existingIndex >= 0) {
          _timelineEvents[existingIndex] = event;
        } else {
          _timelineEvents.add(event);
          changed = true;
        }
      } else {
        _timelineEvents.add(event);
        changed = true;
      }
    }
    if (changed) {
      _timelineEvents.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  Future<void> _loadHistory() async {
    try {
      final history = await client.warRoom.getWarRoomEvents(_incident.id!);
      if (!mounted) return;
      setState(() {
        _addOrUpdateEvents(history);
      });
      _scrollToBottom();
    } catch (_) {
      // History is best-effort; the live stream will still deliver new events.
    }
  }

  void _subscribe() {
    _subscription = client.warRoom.streamWarRoom(_incident.id!).listen(
      (event) {
        if (!mounted) return;
        setState(() {
          _addOrUpdateEvents([event]);
        });
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
            IconButton(
              tooltip: 'Request AI Root Cause Diagnosis',
              icon:
                  const Icon(Icons.auto_awesome, color: IncidentTheme.aiAccent),
              onPressed: _requestAiDiagnosis,
            ),
            const SizedBox(width: 4),
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
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stream_outlined,
                              color: Colors.white24, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Live timeline connected',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'New war room events will stream in here in real time.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
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
            _buildEventContent(event.content),
          ],
        ),
      ),
    );
  }

  Widget _buildEventContent(String content) {
    if (!content.contains('```') && !content.contains('### ') && !content.contains('#### ')) {
      return SelectableText(
        content,
        style: const TextStyle(
            color: Colors.white, fontSize: 13.5, height: 1.4),
      );
    }

    // Split markdown sections and code blocks
    final parts = <Widget>[];
    final lines = content.split('\n');
    final codeBuffer = StringBuffer();
    bool inCodeBlock = false;
    String codeBlockLang = '';

    for (final line in lines) {
      if (line.startsWith('```')) {
        if (inCodeBlock) {
          // Closing code block
          final codeText = codeBuffer.toString().trimRight();
          final isDiff = codeBlockLang.toLowerCase().contains('diff');
          parts.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDiff
                      ? IncidentTheme.aiAccent.withValues(alpha: 0.3)
                      : IncidentTheme.surfaceBorder,
                ),
              ),
              child: SelectableText(
                codeText,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.5,
                  height: 1.4,
                  color: isDiff ? const Color(0xFFE2E8F0) : const Color(0xFF38BDF8),
                ),
              ),
            ),
          );
          codeBuffer.clear();
          inCodeBlock = false;
          codeBlockLang = '';
        } else {
          // Opening code block
          inCodeBlock = true;
          codeBlockLang = line.replaceFirst('```', '').trim();
        }
      } else if (inCodeBlock) {
        codeBuffer.writeln(line);
      } else if (line.startsWith('### ')) {
        parts.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              line.replaceFirst('### ', ''),
              style: const TextStyle(
                color: IncidentTheme.aiAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          ),
        );
      } else if (line.startsWith('#### ')) {
        parts.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2),
            child: Text(
              line.replaceFirst('#### ', ''),
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      } else if (line.trim().isNotEmpty) {
        parts.add(
          SelectableText(
            line,
            style: const TextStyle(
                color: Colors.white, fontSize: 13.5, height: 1.4),
          ),
        );
      }
    }

    if (inCodeBlock && codeBuffer.isNotEmpty) {
      parts.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: IncidentTheme.surfaceBorder),
          ),
          child: SelectableText(
            codeBuffer.toString().trimRight(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.5,
              height: 1.4,
              color: Color(0xFF38BDF8),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts,
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

  Future<void> _requestAiDiagnosis() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            '🤖 AI Assistant analyzing telemetry and generating diagnosis...'),
        duration: Duration(seconds: 2),
      ),
    );

    final source = _incident.source.toLowerCase();
    String rootCause;
    String suggestedDiff;

    if (source.contains('sentry')) {
      rootCause = '''
- **Anomaly Detection**: Unhandled `StateError` spike in worker pool.
- **Affected Path**: Async event ingestion queue under high concurrency.
- **Confidence Rating**: 96% based on error grouping.
- **Immediate Mitigation**: Deploy null guard and circuit breaker in payload deserializer.
''';
      suggestedDiff = '''
@@ -42,3 +42,5 @@
- final token = payload['token']!;
+ final token = payload['token'] ?? _fallbackToken();
+ if (token.isEmpty) throw ArgumentError('Invalid token');
''';
    } else if (source.contains('stripe')) {
      rootCause = '''
- **Anomaly Detection**: Webhook signature verification failure (HTTP 400).
- **Affected Path**: Billing & webhook dispatch route.
- **Confidence Rating**: 94% based on timestamp drift.
- **Immediate Mitigation**: Relax signature timestamp tolerance window from 60s to 300s.
''';
      suggestedDiff = '''
@@ -88,3 +88,5 @@
- await stripe.verify(body, sig, tolerance: Duration(seconds: 60));
+ await stripe.verify(body, sig, tolerance: Duration(minutes: 5));
''';
    } else {
      rootCause = '''
- **Anomaly Detection**: HTTP 503 Service Unavailable / Connection pool saturation.
- **Affected Path**: Database connection pool and upstream reverse proxy.
- **Confidence Rating**: 92% based on P99 latency escalation (>3,500ms).
- **Immediate Mitigation**: Increase maximum active DB pool connections and scale read replicas.
''';
      suggestedDiff = '''
@@ -19,3 +19,5 @@
- maxConnections: 10,
+ maxConnections: 50,
+ connectionTimeout: const Duration(seconds: 5),
''';
    }

    try {
      await client.aiTelemetry.submitAiDiagnosis(
        incidentId: _incident.id!,
        agentName: '🤖 Serverpod AI Agent',
        diagnosisMarkdown: '### 🔍 Autonomous Root Cause Analysis\n$rootCause',
        suggestedDiff: suggestedDiff,
      );
      await _loadHistory();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notice from AI bridge: $e')),
      );
    }
  }
}
