import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../war_room/war_room_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock/initial data for immediate preview and testing
  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'name': 'They Might Byte (Game Server)',
      'slug': 'they-might-byte',
      'status': 'operational',
      'uptime': '99.98%',
      'latency': '42ms',
    },
    {
      'id': 2,
      'name': 'Billing Gateway & Webhooks',
      'slug': 'billing-gateway',
      'status': 'operational',
      'uptime': '100.0%',
      'latency': '18ms',
    },
    {
      'id': 3,
      'name': 'Stripe Checkout Ingress',
      'slug': 'stripe-webhooks',
      'status': 'degraded',
      'uptime': '98.5%',
      'latency': '310ms',
    },
  ];

  final List<Map<String, dynamic>> _activeIncidents = [
    {
      'id': 101,
      'service': 'Stripe Checkout Ingress',
      'title': 'Stripe Webhook Signature Verification Failures',
      'severity': 'high',
      'status': 'triggered',
      'elapsed': '4m ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: IncidentTheme.aiAccent, size: 24),
            SizedBox(width: 8),
            Text('IncidentPulse'),
            SizedBox(width: 12),
            Chip(
              label: Text('Serverpod 4 • Live', style: TextStyle(fontSize: 11, color: Colors.white70)),
              backgroundColor: Color(0xFF1E293B),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Status',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshed health metrics across all services.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: IncidentTheme.aiAccent),
            tooltip: 'AI Assistant Incident Briefing',
            onPressed: _showAiBriefing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Incidents Banner
            if (_activeIncidents.isNotEmpty) ...[
              const Text(
                'ACTIVE ALERTS & WAR ROOMS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: IncidentTheme.statusCritical,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              ..._activeIncidents.map((inc) => _buildIncidentCard(inc)),
              const SizedBox(height: 24),
            ],

            // Monitored Ventures Matrix
            const Text(
              'MONITORED SERVICES & APIS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white54,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 3 : 1,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 140,
                  ),
                  itemCount: _services.length,
                  itemBuilder: (context, index) => _buildServiceCard(_services[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(Map<String, dynamic> inc) {
    return Card(
      color: const Color(0xFF261217),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: IncidentTheme.statusCritical, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: IncidentTheme.statusCritical.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: IncidentTheme.statusCritical, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: IncidentTheme.statusCritical,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          inc['severity'].toString().toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        inc['service'],
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        inc['elapsed'],
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    inc['title'],
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: IncidentTheme.statusCritical,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.meeting_room_rounded, size: 18),
              label: const Text('Enter War Room'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WarRoomScreen(incidentId: inc['id']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isOk = service['status'] == 'operational';
    final statusColor = isOk ? IncidentTheme.statusOperational : IncidentTheme.statusDegraded;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    service['name'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Uptime', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    Text(service['uptime'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Latency', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    Text(service['latency'], style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAiBriefing() {
    showModalBottomSheet(
      context: context,
      backgroundColor: IncidentTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: IncidentTheme.aiAccent),
                SizedBox(width: 10),
                Text(
                  'AI Assistant Reliability Briefing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '• 2 of 3 services are fully operational.\n'
              '• 1 degraded service detected: Stripe webhook signature mismatches in the last 15 minutes.\n'
              '• Automated action: Diagnostic stacktrace attached in the War Room.\n'
              '• Data Privacy: Customer data isolation active. AI telemetry opt-in enforced.',
              style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss', style: TextStyle(color: IncidentTheme.aiAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
