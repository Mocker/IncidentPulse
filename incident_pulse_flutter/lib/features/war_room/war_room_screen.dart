import 'package:flutter/material.dart';
import '../../core/theme.dart';

class WarRoomScreen extends StatefulWidget {
  final int incidentId;
  const WarRoomScreen({super.key, required this.incidentId});

  @override
  State<WarRoomScreen> createState() => _WarRoomScreenState();
}

class _WarRoomScreenState extends State<WarRoomScreen> {
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _timelineEvents = [
    {
      'author': 'Webhook (Stripe)',
      'type': 'alert',
      'time': '12:04 PM',
      'content': 'Webhook signature verification failed on endpoint /v1/webhooks/stripe.',
    },
    {
      'author': 'AI Diagnostic Assistant',
      'type': 'ai_insight',
      'time': '12:05 PM',
      'content': '🤖 **Autonomous Diagnosis**:\n\n'
          'Root cause: Stripe webhook signing secret `whsec_...` expired or was rotated without updating the environment variable `STRIPE_WEBHOOK_SECRET`.\n\n'
          'Recommended fix: Update `.env` or Serverpod `passwords.yaml` with the latest endpoint signing secret.',
    },
    {
      'author': 'On-Call Engineer',
      'type': 'note',
      'time': '12:07 PM',
      'content': 'Acknowledged. Checking the Stripe developer dashboard now to verify the endpoint secret.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.circle, color: IncidentTheme.statusCritical, size: 10),
                const SizedBox(width: 8),
                Text('War Room: Incident #${widget.incidentId}'),
              ],
            ),
            const Text(
              'Stripe Checkout Webhooks • WebSockets Streaming Active',
              style: TextStyle(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: IncidentTheme.statusOperational,
              side: const BorderSide(color: IncidentTheme.statusOperational),
            ),
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Resolve Incident'),
            onPressed: _showResolveDialog,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // Timeline Stream
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _timelineEvents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) => _buildEventTile(_timelineEvents[index]),
            ),
          ),

          // Message & Note Ingress Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: IncidentTheme.surface,
              border: Border(top: BorderSide(color: IncidentTheme.surfaceBorder, width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Post a note or diagnostic command to the War Room...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendNote(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: IncidentTheme.aiAccent),
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

  Widget _buildEventTile(Map<String, dynamic> event) {
    final isAi = event['type'] == 'ai_insight';
    final isAlert = event['type'] == 'alert';

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
          color: isAi ? IncidentTheme.aiAccent.withOpacity(0.4) : IncidentTheme.surfaceBorder,
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
                Text(
                  event['author'],
                  style: TextStyle(fontWeight: FontWeight.w600, color: authorColor, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  event['time'],
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event['content'],
              style: const TextStyle(color: Colors.white, fontSize: 13.5, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _timelineEvents.add({
        'author': 'On-Call Engineer',
        'type': 'note',
        'time': 'Just now',
        'content': text,
      });
    });
    _noteController.clear();
  }

  void _showResolveDialog() {
    final rootCauseController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: IncidentTheme.surface,
        title: const Text('Resolve Incident', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Document root cause for post-mortem & reliability analytics:', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: rootCauseController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'e.g. Updated STRIPE_WEBHOOK_SECRET in production config.',
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: IncidentTheme.statusOperational),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Incident marked as Resolved.')),
              );
            },
            child: const Text('Confirm Resolution', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
