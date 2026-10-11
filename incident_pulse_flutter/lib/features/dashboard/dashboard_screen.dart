import 'dart:async';
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
  List<Incident> _allIncidents = [];
  String _selectedFilter = 'active'; // 'active', 'triggered', 'acknowledged', 'resolved'
  bool _loading = true;
  bool _simulating = false;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Keep the board fresh so new incidents appear without manual refresh.
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 20), (_) => _loadData(silent: true));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final results = await Future.wait([
        client.service.listServices(),
        client.incident.getActiveIncidents(),
        client.incident.getAllIncidents(limit: 100),
      ]);
      if (!mounted) return;
      setState(() {
        _services = (results[0] as List<Service>);
        _activeIncidents = (results[1] as List<Incident>);
        _allIncidents = (results[2] as List<Incident>);
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      // Silent background refreshes shouldn't clobber the visible board.
      if (silent) return;
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
          _simulating
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: IncidentTheme.aiAccent,
                      ),
                    ),
                  ),
                )
              : PopupMenuButton<String>(
                  tooltip: 'Simulate Incoming Webhook Alert',
                  icon: const Icon(Icons.flash_on, color: Color(0xFFF59E0B)),
                  onSelected: _triggerSimulation,
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'sentry',
                      child: Row(
                        children: [
                          Icon(Icons.bug_report_outlined, size: 18, color: Colors.orangeAccent),
                          SizedBox(width: 10),
                          Text('Simulate Sentry Crash Alert'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'stripe',
                      child: Row(
                        children: [
                          Icon(Icons.payment_outlined, size: 18, color: Colors.redAccent),
                          SizedBox(width: 10),
                          Text('Simulate Stripe Payment Failure'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'uptime',
                      child: Row(
                        children: [
                          Icon(Icons.cloud_off_outlined, size: 18, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Simulate Uptime Outage (503)'),
                        ],
                      ),
                    ),
                  ],
                ),
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
            // Active Incidents Banner & Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'INCIDENTS & WAR ROOMS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: IncidentTheme.statusCritical,
                    letterSpacing: 1.2,
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    ChoiceChip(
                      label: Text('Active (${_activeIncidents.length})', style: const TextStyle(fontSize: 11)),
                      selected: _selectedFilter == 'active',
                      onSelected: (_) => setState(() => _selectedFilter = 'active'),
                    ),
                    ChoiceChip(
                      label: Text(
                        'Triggered (${_allIncidents.where((i) => i.status == 'triggered').length})',
                        style: const TextStyle(fontSize: 11),
                      ),
                      selected: _selectedFilter == 'triggered',
                      onSelected: (_) => setState(() => _selectedFilter = 'triggered'),
                    ),
                    ChoiceChip(
                      label: Text(
                        'Resolved (${_allIncidents.where((i) => i.status == 'resolved').length})',
                        style: const TextStyle(fontSize: 11),
                      ),
                      selected: _selectedFilter == 'resolved',
                      onSelected: (_) => setState(() => _selectedFilter = 'resolved'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            () {
              final displayed = _selectedFilter == 'active'
                  ? _activeIncidents
                  : _selectedFilter == 'triggered'
                      ? _allIncidents.where((i) => i.status == 'triggered').toList()
                      : _allIncidents.where((i) => i.status == 'resolved').toList();

              if (displayed.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: IncidentTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: IncidentTheme.surfaceBorder),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: IncidentTheme.statusOperational
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: IncidentTheme.statusOperational,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFilter == 'resolved' ? 'No resolved incidents recorded yet' : 'All quiet',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedFilter == 'resolved'
                            ? 'Resolved incidents and post-mortem root causes will appear here.'
                            : '${_services.length} service${_services.length == 1 ? '' : 's'} monitored • probes running • no active incidents',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12.5),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: displayed.map((inc) => _buildIncidentCard(inc)).toList(),
              );
            }(),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;
        final content = Expanded(
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
                'Status: ${inc.status.toUpperCase()} • Source: ${inc.source}',
                style:
                    const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              if (inc.rootCause != null && inc.rootCause!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: IncidentTheme.statusOperational.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: IncidentTheme.statusOperational.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Root Cause: ${inc.rootCause}',
                    style: const TextStyle(
                      color: IncidentTheme.statusOperational,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );

        final warRoomButton = ElevatedButton.icon(
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
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF261217),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: accent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.warning_amber_rounded,
                                color: accent, size: 28),
                          ),
                          const SizedBox(width: 16),
                          content,
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                          width: double.infinity, child: warRoomButton),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.warning_amber_rounded,
                            color: accent, size: 28),
                      ),
                      const SizedBox(width: 16),
                      content,
                      const SizedBox(width: 16),
                      warRoomButton,
                    ],
                  ),
          ),
        );
      },
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

  Future<void> _triggerSimulation(String source) async {
    setState(() => _simulating = true);
    try {
      final incident = await client.incident.simulateMockAlert(source: source);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: IncidentTheme.statusCritical,
          content: Text(
            '⚡ Simulated [$source] alert injected: Incident #${incident.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          action: SnackBarAction(
            label: 'Open War Room',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WarRoomScreen(
                    incident: incident,
                    serviceName: _serviceName(incident.serviceId),
                  ),
                ),
              ).then((_) => _loadData());
            },
          ),
        ),
      );
      await _loadData(silent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Simulation failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _simulating = false);
    }
  }
}
