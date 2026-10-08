import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:incident_pulse_client/incident_pulse_client.dart';
import '../../core/client.dart';
import '../../core/theme.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final _nameController = TextEditingController();
  final _pingUrlController = TextEditingController();
  final _pingHeadersController = TextEditingController();

  final _hookNameController = TextEditingController();
  final _hookUrlController = TextEditingController();
  final _hookSecretController = TextEditingController();

  List<Service> _services = [];
  List<WebhookSubscription> _subscriptions = [];
  bool _loading = true;
  String? _error;
  final Set<int> _busyServiceIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pingUrlController.dispose();
    _pingHeadersController.dispose();
    _hookNameController.dispose();
    _hookUrlController.dispose();
    _hookSecretController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        client.service.listServices(),
        client.webhookSubscription.listSubscriptions(),
      ]);
      if (!mounted) return;
      setState(() {
        _services = results[0] as List<Service>;
        _subscriptions = results[1] as List<WebhookSubscription>;
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

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services, Privacy & Data Retention'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: IncidentTheme.aiAccent),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  color: Colors.white38, size: 48),
              const SizedBox(height: 16),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 13, height: 1.5)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: IncidentTheme.aiAccent),
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
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MONITORED SERVICES & TENANTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                  letterSpacing: 1.2,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: IncidentTheme.aiAccent),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Service'),
                onPressed: _showAddServiceDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_services.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No services registered yet.',
                  style: TextStyle(color: Colors.white38, fontSize: 13)),
            )
          else
            ..._services.map((s) => _buildServiceItem(s)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OUTBOUND NOTIFICATION WEBHOOKS (BYOE)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white54,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Deliver JSON alerts & HMAC signatures to Slack, Discord, PagerDuty, or custom HTTP',
                      style:
                          TextStyle(fontSize: 11, color: Colors.white38),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB)),
                icon: const Icon(Icons.add_link, size: 18),
                label: const Text('Add Webhook'),
                onPressed: _showAddWebhookDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_subscriptions.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: IncidentTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: IncidentTheme.surfaceBorder),
              ),
              child: const Center(
                child: Text('No outbound webhooks registered yet.',
                    style:
                        TextStyle(color: Colors.white38, fontSize: 13)),
              ),
            )
          else
            ..._subscriptions.map((w) => _buildWebhookItem(w)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Service s) {
    final isInternal = s.isInternalOwner;
    final busy = _busyServiceIds.contains(s.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(s.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      if (isInternal)
                        const Chip(
                          label: Text('INTERNAL SERVICE',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70)),
                          backgroundColor: Color(0xFF1E293B),
                          visualDensity: VisualDensity.compact,
                        )
                      else
                        const Chip(
                          label: Text('CUSTOMER TENANT',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          backgroundColor: Color(0xFF2A1C0E),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(s.status.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold)),
                  backgroundColor: s.status == 'operational'
                      ? IncidentTheme.statusOperational
                          .withValues(alpha: 0.2)
                      : IncidentTheme.statusDegraded.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: s.status == 'operational'
                        ? IncidentTheme.statusOperational
                        : IncidentTheme.statusDegraded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ingress webhook key
            const Text('Ingress Webhook Key:',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 2),
            const Text(
              'POST to webhook.ingestWebhook with this key as webhookKey',
              style: TextStyle(color: Colors.white38, fontSize: 10.5),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: IncidentTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      s.webhookKey,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy,
                        size: 16, color: IncidentTheme.aiAccent),
                    tooltip: 'Copy Webhook Key',
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: s.webhookKey));
                      _snack('Webhook key copied to clipboard!');
                    },
                  ),
                ],
              ),
            ),

            if (s.pingUrl != null && s.pingUrl!.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Synthetic Health Probe Target:',
                  style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: IncidentTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.radar,
                        size: 15, color: IncidentTheme.aiAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.pingUrl!,
                        style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (s.pingHeaders != null &&
                        s.pingHeaders!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shield_outlined,
                                size: 11, color: Colors.amberAccent),
                            SizedBox(width: 4),
                            Text(
                              'Zero Trust Headers',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),

            // Privacy, Opt-In & Compliance Controls
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1524),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: IncidentTheme.surfaceBorder
                        .withValues(alpha: 0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRIVACY & COMPLIANCE CONFIGURATION',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                        letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),

                  // AI Telemetry Bridge Opt-in Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                size: 16,
                                color: IncidentTheme.aiAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                      'AI Assistant Telemetry Bridge',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  Text(
                                    isInternal
                                        ? 'Internal service — always visible to bridge'
                                        : 'Strictly Opt-In (Off by default for customers)',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white38),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: s.enableAiBridge,
                        activeThumbColor: IncidentTheme.aiAccent,
                        onChanged: busy
                            ? null
                            : (val) => _updatePrivacy(
                                  s,
                                  enableAiBridge: val,
                                  dataRetentionDays:
                                      s.dataRetentionDays,
                                  redactPii: s.redactPii,
                                ),
                      ),
                    ],
                  ),
                  const Divider(
                      color: IncidentTheme.surfaceBorder, height: 16),

                  // Data Retention Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data Retention Period',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text('Raw payload & PII auto-purge window',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white38)),
                        ],
                      ),
                      DropdownButton<int>(
                        value: s.dataRetentionDays,
                        dropdownColor: IncidentTheme.surface,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                              value: 30,
                              child: Text('30 Days (Strict GDPR)')),
                          DropdownMenuItem(
                              value: 90,
                              child: Text('90 Days (Standard)')),
                          DropdownMenuItem(
                              value: 180, child: Text('180 Days')),
                          DropdownMenuItem(
                              value: 365,
                              child: Text('365 Days (SOC2)')),
                        ],
                        onChanged: busy
                            ? null
                            : (val) {
                                if (val != null) {
                                  _updatePrivacy(
                                    s,
                                    enableAiBridge: s.enableAiBridge,
                                    dataRetentionDays: val,
                                    redactPii: s.redactPii,
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                  const Divider(
                      color: IncidentTheme.surfaceBorder, height: 16),

                  // Compliance Actions: GDPR Purge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(
                              color: Colors.redAccent, width: 0.8),
                        ),
                        icon: const Icon(Icons.delete_sweep, size: 16),
                        label: const Text('GDPR Purge Payloads',
                            style: TextStyle(fontSize: 12)),
                        onPressed:
                            busy ? null : () => _confirmPurgeDialog(s),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePrivacy(
    Service s, {
    required bool enableAiBridge,
    required int dataRetentionDays,
    required bool redactPii,
  }) async {
    setState(() => _busyServiceIds.add(s.id!));
    try {
      final updated = await client.service.updatePrivacyAndRetention(
        serviceId: s.id!,
        enableAiBridge: enableAiBridge,
        dataRetentionDays: dataRetentionDays,
        redactPii: redactPii,
      );
      if (!mounted) return;
      if (updated != null) {
        setState(() {
          final i = _services.indexWhere((x) => x.id == s.id);
          if (i >= 0) _services[i] = updated;
        });
        _snack(
            'Privacy updated: AI Bridge ${enableAiBridge ? "ENABLED" : "DISABLED (Tenant Isolated)"}, retention $dataRetentionDays days.');
      }
    } catch (e) {
      _snack('Privacy update failed: $e');
    } finally {
      if (mounted) setState(() => _busyServiceIds.remove(s.id));
    }
  }

  void _confirmPurgeDialog(Service s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: IncidentTheme.surface,
        title: const Text('Execute Data Erasure (GDPR / Compliance)',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'This will purge all raw webhook payloads, request headers, and sensitive data for "${s.name}".\n\n'
          'High-level post-mortem summaries, incident counts, and MTTR timestamps will remain intact for audit reporting.',
          style: const TextStyle(
              color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await _purgeService(s);
            },
            child: const Text('Purge Raw Data',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _purgeService(Service s) async {
    setState(() => _busyServiceIds.add(s.id!));
    try {
      final ok = await client.service.purgeServiceHistory(
        serviceId: s.id!,
        purgeEntireIncidents: false,
      );
      _snack(ok
          ? 'Raw payloads purged for ${s.name}. Metadata retained for post-mortem analysis.'
          : 'Purge did not complete on the server.');
    } catch (e) {
      _snack('Purge failed: $e');
    } finally {
      if (mounted) setState(() => _busyServiceIds.remove(s.id));
    }
  }

  void _showAddServiceDialog() {
    bool isAiOptIn = false;
    int retentionDays = 90;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: IncidentTheme.surface,
          title: const Text('Register New Service',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Service / Micro-SaaS Name',
                    hintText: 'e.g. Acme Billing API',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pingUrlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Synthetic Health Ping URL (Optional)',
                    hintText: 'https://api.acme.com/health',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pingHeadersController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Custom Ping Headers (Optional)',
                    hintText:
                        'CF-Access-Client-Id: xxx\nCF-Access-Client-Secret: yyy',
                    helperText:
                        'Key: Value per line (e.g. Cloudflare Zero Trust service tokens)',
                    helperStyle:
                        TextStyle(fontSize: 10.5, color: Colors.white38),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Data Retention Window:',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12)),
                DropdownButton<int>(
                  value: retentionDays,
                  dropdownColor: IncidentTheme.surface,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 13),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                        value: 30,
                        child: Text('30 Days (Strict GDPR)')),
                    DropdownMenuItem(
                        value: 90, child: Text('90 Days (Standard)')),
                    DropdownMenuItem(
                        value: 180, child: Text('180 Days')),
                    DropdownMenuItem(
                        value: 365, child: Text('365 Days (SOC2)')),
                  ],
                  onChanged: (val) {
                    if (val != null)
                      setDialogState(() => retentionDays = val);
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: IncidentTheme.aiAccent,
                  title: const Text(
                      'AI Telemetry Bridge (Autonomous Diagnosis)',
                      style:
                          TextStyle(fontSize: 12, color: Colors.white)),
                  subtitle: const Text(
                      'Off by default for third-party customer privacy',
                      style: TextStyle(
                          fontSize: 10.5, color: Colors.white38)),
                  value: isAiOptIn,
                  onChanged: (val) =>
                      setDialogState(() => isAiOptIn = val ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                _pingUrlController.clear();
                _pingHeadersController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: IncidentTheme.aiAccent),
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;

                Map<String, String>? parsedHeaders;
                final rawHeaders = _pingHeadersController.text.trim();
                if (rawHeaders.isNotEmpty) {
                  parsedHeaders = {};
                  for (final line in rawHeaders.split('\n')) {
                    final idx = line.indexOf(':');
                    if (idx > 0) {
                      final key = line.substring(0, idx).trim();
                      final val = line.substring(idx + 1).trim();
                      if (key.isNotEmpty && val.isNotEmpty) {
                        parsedHeaders[key] = val;
                      }
                    }
                  }
                  if (parsedHeaders.isEmpty) parsedHeaders = null;
                }

                final pingUrl = _pingUrlController.text.trim();
                Navigator.pop(context);
                try {
                  final created = await client.service.createService(
                    name: name,
                    slug: name.toLowerCase().replaceAll(' ', '-'),
                    pingUrl: pingUrl.isEmpty ? null : pingUrl,
                    pingHeaders: parsedHeaders,
                    checkIntervalSeconds: 60,
                    isInternalOwner: false,
                    enableAiBridge: isAiOptIn,
                    dataRetentionDays: retentionDays,
                    redactPii: true,
                  );
                  if (!mounted) return;
                  setState(() => _services.add(created));
                  _snack('Service "${created.name}" registered.');
                } catch (e) {
                  _snack('Service creation failed: $e');
                } finally {
                  _nameController.clear();
                  _pingUrlController.clear();
                  _pingHeadersController.clear();
                }
              },
              child: const Text('Create Service',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebhookItem(WebhookSubscription w) {
    final hasSecret =
        w.secretKey != null && w.secretKey!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.webhook,
                          size: 18, color: Color(0xFF60A5FA)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          w.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (hasSecret)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Colors.greenAccent
                                  .withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_outlined,
                                size: 11, color: Colors.greenAccent),
                            SizedBox(width: 4),
                            Text('HMAC Signed',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 16, color: Colors.white38),
                      tooltip: 'Delete Webhook',
                      onPressed: () => _deleteSubscription(w),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: IncidentTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      w.targetUrl,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.5,
                          color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                    icon: const Icon(Icons.send_rounded,
                        size: 13, color: Color(0xFF60A5FA)),
                    label: const Text('Test Ping',
                        style: TextStyle(
                            fontSize: 11, color: Color(0xFF60A5FA))),
                    onPressed: () => _testSubscription(w),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: w.events.map((ev) {
                return Chip(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: const Color(0xFF131B2E),
                  label: Text(
                    ev,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontFamily: 'monospace'),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSubscription(WebhookSubscription w) async {
    try {
      final ok = await client.webhookSubscription
          .deleteSubscription(subscriptionId: w.id!);
      if (!mounted) return;
      if (ok) {
        setState(() =>
            _subscriptions.removeWhere((x) => x.id == w.id));
        _snack('Webhook "${w.name}" removed.');
      }
    } catch (e) {
      _snack('Delete failed: $e');
    }
  }

  Future<void> _testSubscription(WebhookSubscription w) async {
    _snack('Sending test ping to "${w.name}"…');
    try {
      final result = await client.webhookSubscription
          .testSubscription(subscriptionId: w.id!);
      if (!mounted) return;
      final success = result['success'] == true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: IncidentTheme.surface,
          title: Text(
            success ? 'Test Ping Delivered' : 'Test Ping Failed',
            style: TextStyle(
                color: success
                    ? IncidentTheme.statusOperational
                    : IncidentTheme.statusCritical),
          ),
          content: Text(
            success
                ? 'HTTP ${result['statusCode']} from ${w.targetUrl}\n\nThe receiver got incident.test_ping with a valid HMAC signature.'
                : 'Error: ${result['error'] ?? 'HTTP ${result['statusCode']}'}',
            style: const TextStyle(
                color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(color: IncidentTheme.aiAccent)),
            ),
          ],
        ),
      );
    } catch (e) {
      _snack('Test ping failed: $e');
    }
  }

  void _showAddWebhookDialog() {
    final events = <String>{
      'incident.triggered',
      'incident.escalated',
      'incident.resolved',
    };

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: IncidentTheme.surface,
          title: const Text('Register Outbound Webhook',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _hookNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Integration Name',
                    hintText: 'e.g. Slack #incidents or PagerDuty',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _hookUrlController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'Target URL (HTTP POST)',
                    hintText: 'https://hooks.slack.com/services/...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _hookSecretController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: 'HMAC Secret Key (Optional)',
                    hintText: 'Secret for X-IncidentPulse-Signature',
                    helperText:
                        'Enables payload authenticity verification on your receiver',
                    helperStyle: TextStyle(
                        fontSize: 10.5, color: Colors.white38),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Subscribed Lifecycle Events:',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...[
                  'incident.triggered',
                  'incident.acknowledged',
                  'incident.escalated',
                  'incident.resolved'
                ].map((ev) {
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF2563EB),
                    title: Text(ev,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontFamily: 'monospace')),
                    value: events.contains(ev),
                    onChanged: (val) {
                      setDialogState(() {
                        if (val == true) {
                          events.add(ev);
                        } else {
                          events.remove(ev);
                        }
                      });
                    },
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _hookNameController.clear();
                _hookUrlController.clear();
                _hookSecretController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB)),
              onPressed: () async {
                final name = _hookNameController.text.trim();
                final url = _hookUrlController.text.trim();
                if (name.isEmpty || url.isEmpty) return;
                final secret = _hookSecretController.text.trim();

                Navigator.pop(context);
                try {
                  final created = await client.webhookSubscription
                      .createSubscription(
                    name: name,
                    targetUrl: url,
                    secretKey: secret.isEmpty ? null : secret,
                    events: events.toList(),
                  );
                  if (!mounted) return;
                  setState(() => _subscriptions.insert(0, created));
                  _snack('Webhook "${created.name}" registered.');
                } catch (e) {
                  _snack('Webhook registration failed: $e');
                } finally {
                  _hookNameController.clear();
                  _hookUrlController.clear();
                  _hookSecretController.clear();
                }
              },
              child: const Text('Register Webhook',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
