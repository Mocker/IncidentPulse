import 'package:flutter/material.dart';
import 'package:incident_pulse_client/incident_pulse_client.dart';
import '../../core/client.dart';
import '../../core/theme.dart';
import '../war_room/war_room_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Service> _services = [];
  List<Incident> _activeIncidents = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        client.service.listServices(),
        client.incident.getActiveIncidents(),
      ]);
      if (!mounted) return;
      setState(() {
        _services = (results[0] as List<Service>);
        _activeIncidents = (results[1] as List<Incident>);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not reach the IncidentPulse server.\n$e';
      });
    }
  }

  String _serviceName(int serviceId) {
    for (final s in _services) {
      if (s.id == serviceId) return s.name;
    }
    return 'Service #$serviceId';
  }

  String _elapsed(DateTime t) {
    final d = DateTime.now().difference(t.toLocal());
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

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
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: IncidentTheme.aiAccent),
            tooltip: 'AI Assistant Incident Briefing',
            onPressed: _showAiBriefing,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: IncidentTheme.aiAccent),
            SizedBox(height: 12),
            Text('Connecting to IncidentPulse server…',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, color: Colors.white38, size: 48),
              const SizedBox(height: 16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: IncidentTheme.aiAccent),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry Connection'),
                onPressed: _loadData,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: IncidentTheme.aiAccent,
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Incidents Banner
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
            if (_activeIncidents.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: IncidentTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: IncidentTheme.surfaceBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: IncidentTheme.statusOperational, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All quiet. No active incidents across monitored services.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._activeIncidents.map((inc) => _buildIncidentCard(inc)),
            const SizedBox(height: 24),

            // Monitored Services Matrix
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
            if (_services.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: IncidentTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: IncidentTheme.surfaceBorder),
                ),
                child: const Text(
                  'No services registered yet. Add one from the Services tab.',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              )
            else
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
                    itemBuilder: (context, index) =>
                        _buildServiceCard(_services[index]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(Incident inc) {
    final isCritical = inc.severity == 'critical';
    final accent =
        isCritical ? IncidentTheme.statusCritical : const Color(0xFFF59E0B);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF261217),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: accent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_amber_rounded, color: accent, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          inc.severity.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _serviceName(inc.serviceId),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _elapsed(inc.triggeredAt),
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    inc.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Status: ${inc.status} • Source: ${inc.source}',
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.meeting_room_rounded, size: 18),
              label: const Text('Enter War Room'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WarRoomScreen(
                      incident: inc,
                      serviceName: _serviceName(inc.serviceId),
                    ),
                  ),
                ).then((_) => _loadData());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    final status = service.status;
    final statusColor = status == 'operational'
        ? IncidentTheme.statusOperational
        : status == 'degraded'
            ? IncidentTheme.statusDegraded
            : IncidentTheme.statusCritical;

    String probeLine;
    if (service.lastPingAt != null) {
      final code = service.lastPingStatus != null
          ? 'HTTP ${service.lastPingStatus}'
          : 'no response';
      probeLine = 'Last probe ${_elapsed(service.lastPingAt!)} • $code';
    } else {
      probeLine = service.pingUrl != null
          ? 'Probe scheduled • ${service.pingUrl}'
          : 'No health probe configured';
    }

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
                    service.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              probeLine,
              style: const TextStyle(color: Colors.white38, fontSize: 11.5),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAiBriefing() async {
    Map<String, dynamic>? summary;
    try {
      summary = await client.aiTelemetry.getTelemetrySummary();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI briefing unavailable: $e')),
      );
      return;
    }
    if (!mounted) return;

    final operational = summary['operationalCount'] ?? 0;
    final degraded = summary['degradedCount'] ?? 0;
    final down = summary['downCount'] ?? 0;
    final active = summary['activeIncidentCount'] ?? 0;
    final critical = (summary['criticalIncidents'] as List?) ?? [];

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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '• $operational operational, $degraded degraded, $down down.\n'
              '• $active active incident${active == 1 ? '' : 's'} across opted-in services.\n'
              '${critical.isEmpty ? '• No critical incidents right now.' : '• ${critical.length} CRITICAL incident${critical.length == 1 ? '' : 's'} need attention.'}\n'
              '• Data Privacy: customer data isolation active. AI telemetry opt-in enforced.',
              style: const TextStyle(
                  color: Colors.white70, height: 1.5, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Dismiss',
                    style: TextStyle(color: IncidentTheme.aiAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
