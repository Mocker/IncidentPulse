import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final _nameController = TextEditingController();
  final _pingUrlController = TextEditingController();
  final _pingHeadersController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pingUrlController.dispose();
    _pingHeadersController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'name': 'Ryan Guthrie Portfolio',
      'slug': 'ryan-portfolio',
      'webhookUrl': 'http://localhost:8080/v1/webhook?key=whk_seed_ryan_portfolio',
      'pingUrl': 'https://ryanguthrie.com',
      'pingHeaders': null,
      'status': 'operational',
      'isInternalOwner': true,
      'enableAiBridge': true, // Internal project
      'retentionDays': 365,
      'redactPii': true,
    },
    {
      'id': 2,
      'name': 'n8n Automation Hub',
      'slug': 'n8n-hub',
      'webhookUrl': 'http://localhost:8080/v1/webhook?key=whk_seed_n8n_hub',
      'pingUrl': 'https://n8n.ryanguthrie.com/healthz',
      'pingHeaders': {
        'CF-Access-Client-Id': '••••••••.access',
        'CF-Access-Client-Secret': '••••••••••••••••',
      },
      'status': 'operational',
      'isInternalOwner': true,
      'enableAiBridge': true, // Internal project
      'retentionDays': 365,
      'redactPii': true,
    },
    {
      'id': 3,
      'name': 'Acme Corp Micro-SaaS (Customer)',
      'slug': 'acme-corp',
      'webhookUrl': 'http://localhost:8080/v1/webhook?key=acme_sec_884129cc0',
      'pingUrl': 'https://api.acmecorp.com/health',
      'pingHeaders': null,
      'status': 'degraded',
      'isInternalOwner': false,
      'enableAiBridge': false, // External customer: strictly off by default
      'retentionDays': 30, // Strict compliance window
      'redactPii': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services, Privacy & Data Retention'),
      ),
      body: ListView(
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
                style: ElevatedButton.styleFrom(backgroundColor: IncidentTheme.aiAccent),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Service'),
                onPressed: _showAddServiceDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._services.map((s) => _buildServiceItem(s)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> s) {
    final isInternal = s['isInternalOwner'] as bool;
    final isAiEnabled = s['enableAiBridge'] as bool;

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
                      Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                      const SizedBox(width: 8),
                      if (isInternal)
                        const Chip(
                          label: Text('INTERNAL SERVICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white70)),
                          backgroundColor: Color(0xFF1E293B),
                          visualDensity: VisualDensity.compact,
                        )
                      else
                        const Chip(
                          label: Text('CUSTOMER TENANT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.amber)),
                          backgroundColor: Color(0xFF2A1C0E),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
                Chip(
                  label: Text((s['status'] as String).toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  backgroundColor: s['status'] == 'operational'
                      ? IncidentTheme.statusOperational.withValues(alpha: 0.2)
                      : IncidentTheme.statusDegraded.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: s['status'] == 'operational' ? IncidentTheme.statusOperational : IncidentTheme.statusDegraded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ingress Webhook URL
            const Text('Ingress Webhook Endpoint:', style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: IncidentTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      s['webhookUrl'] as String,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16, color: IncidentTheme.aiAccent),
                    tooltip: 'Copy Webhook URL',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: s['webhookUrl'] as String));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Webhook URL copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
            ),

            if (s['pingUrl'] != null && (s['pingUrl'] as String).isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Synthetic Health Probe Target:', style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: IncidentTheme.surfaceBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.radar, size: 15, color: IncidentTheme.aiAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s['pingUrl'] as String,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (s['pingHeaders'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 11, color: Colors.amberAccent),
                            SizedBox(width: 4),
                            Text(
                              'Zero Trust Headers',
                              style: TextStyle(fontSize: 10, color: Colors.amberAccent, fontWeight: FontWeight.bold),
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
                border: Border.all(color: IncidentTheme.surfaceBorder.withValues(alpha: 0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRIVACY & COMPLIANCE CONFIGURATION',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 8),

                  // AI Telemetry Bridge Opt-in Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, size: 16, color: IncidentTheme.aiAccent),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('AI Assistant Telemetry Bridge', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white)),
                              Text(
                                isInternal ? 'Enabled (Internal Service)' : 'Strictly Opt-In (Off by default for customers)',
                                style: const TextStyle(fontSize: 11, color: Colors.white38),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch(
                        value: isAiEnabled,
                        activeThumbColor: IncidentTheme.aiAccent,
                        onChanged: (val) {
                          setState(() {
                            s['enableAiBridge'] = val;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('AI Bridge updated: ${val ? "ENABLED" : "DISABLED (Tenant Isolated)"}')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(color: IncidentTheme.surfaceBorder, height: 16),

                  // Data Retention Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data Retention Period', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('Raw payload & PII auto-purge window', style: TextStyle(fontSize: 11, color: Colors.white38)),
                        ],
                      ),
                      DropdownButton<int>(
                        value: s['retentionDays'] as int,
                        dropdownColor: IncidentTheme.surface,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 30, child: Text('30 Days (Strict GDPR)')),
                          DropdownMenuItem(value: 90, child: Text('90 Days (Standard)')),
                          DropdownMenuItem(value: 180, child: Text('180 Days')),
                          DropdownMenuItem(value: 365, child: Text('365 Days (SOC2)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => s['retentionDays'] = val);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(color: IncidentTheme.surfaceBorder, height: 16),

                  // Compliance Actions: Review History / GDPR Purge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.history, size: 16, color: Colors.white70),
                        label: const Text('Past Incident History', style: TextStyle(fontSize: 12, color: Colors.white70)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Viewing past post-mortems and MTTR reports (Compliant audit view).')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent, width: 0.8),
                        ),
                        icon: const Icon(Icons.delete_sweep, size: 16),
                        label: const Text('GDPR Purge Payloads', style: TextStyle(fontSize: 12)),
                        onPressed: () => _confirmPurgeDialog(s),
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

  void _confirmPurgeDialog(Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: IncidentTheme.surface,
        title: const Text('Execute Data Erasure (GDPR / Compliance)', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'This will purge all raw webhook payloads, request headers, and sensitive data for "${s['name']}".\n\n'
          'High-level post-mortem summaries, incident counts, and MTTR timestamps will remain intact for audit reporting.',
          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Raw payloads purged for ${s['name']}. Metadata retained for post-mortem analysis.')),
              );
            },
            child: const Text('Purge Raw Data', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    bool isAiOptIn = false;
    int retentionDays = 90;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: IncidentTheme.surface,
          title: const Text('Register New Service', style: TextStyle(color: Colors.white)),
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
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Custom Ping Headers (Optional)',
                    hintText: 'CF-Access-Client-Id: xxx\nCF-Access-Client-Secret: yyy',
                    helperText: 'Key: Value per line (e.g. Cloudflare Zero Trust service tokens)',
                    helperStyle: TextStyle(fontSize: 10.5, color: Colors.white38),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Data Retention Window:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                DropdownButton<int>(
                  value: retentionDays,
                  dropdownColor: IncidentTheme.surface,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 30, child: Text('30 Days (Strict GDPR)')),
                    DropdownMenuItem(value: 90, child: Text('90 Days (Standard)')),
                    DropdownMenuItem(value: 180, child: Text('180 Days')),
                    DropdownMenuItem(value: 365, child: Text('365 Days (SOC2)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => retentionDays = val);
                  },
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: IncidentTheme.aiAccent,
                  title: const Text('AI Telemetry Bridge (Autonomous Diagnosis)', style: TextStyle(fontSize: 12, color: Colors.white)),
                  subtitle: const Text('Off by default for third-party customer privacy', style: TextStyle(fontSize: 10.5, color: Colors.white38)),
                  value: isAiOptIn,
                  onChanged: (val) => setDialogState(() => isAiOptIn = val ?? false),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: IncidentTheme.aiAccent),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  Map<String, String>? parsedHeaders;
                  if (_pingHeadersController.text.trim().isNotEmpty) {
                    parsedHeaders = {};
                    for (final line in _pingHeadersController.text.trim().split('\n')) {
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

                  setState(() {
                    _services.add({
                      'id': _services.length + 1,
                      'name': _nameController.text.trim(),
                      'slug': _nameController.text.trim().toLowerCase().replaceAll(' ', '-'),
                      'webhookUrl': 'http://localhost:8080/v1/webhook?key=sec_${DateTime.now().millisecondsSinceEpoch}',
                      'pingUrl': _pingUrlController.text.trim().isNotEmpty ? _pingUrlController.text.trim() : null,
                      'pingHeaders': parsedHeaders,
                      'status': 'operational',
                      'isInternalOwner': false,
                      'enableAiBridge': isAiOptIn,
                      'retentionDays': retentionDays,
                      'redactPii': true,
                    });
                  });
                  _nameController.clear();
                  _pingUrlController.clear();
                  _pingHeadersController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Create Service', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
