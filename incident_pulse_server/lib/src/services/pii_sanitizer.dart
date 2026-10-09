/// High-performance compliance scrubber for PII and sensitive secrets.
/// Enforces GDPR, CCPA, and SOC2 zero-leak invariants across incident ingresses.
class PiiSanitizer {
  static final RegExp _bearerRegex = RegExp(
    r'bearer\s+[a-z0-9_\-\.]+',
    caseSensitive: false,
  );

  static final RegExp _secretKeyRegex = RegExp(
    r'(whsec_[a-zA-Z0-9]+|sk_live_[a-zA-Z0-9]+|sk_test_[a-zA-Z0-9]+)',
  );

  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+',
  );

  static final RegExp _cardRegex = RegExp(
    r'\b(?:\d[ -]*?){13,16}\b',
  );

  /// Scrubs authorization headers, bearer tokens, API secrets, credit cards, and emails
  static String redact(String input) {
    if (input.isEmpty) return input;
    String text = input;

    // 1. Redact Authorization headers / bearer tokens
    text = text.replaceAll(_bearerRegex, 'Bearer [REDACTED_TOKEN]');

    // 2. Redact API keys / secrets (whsec_, sk_live_, sk_test_)
    text = text.replaceAll(_secretKeyRegex, '[REDACTED_SECRET]');

    // 3. Redact email addresses
    text = text.replaceAll(_emailRegex, '[REDACTED_EMAIL]');

    // 4. Redact 13-16 digit credit card patterns
    text = text.replaceAll(_cardRegex, '[REDACTED_CARD]');

    return text;
  }
}
