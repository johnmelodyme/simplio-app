import 'package:convert/convert.dart';
import 'package:uuid/uuid.dart';

// TODO - It will be turned into a package.
/// Create a OS package for validating WalletConnect URI for v1 and v2
/// https://eips.ethereum.org/EIPS/eip-1328.
/// Provide a mixin for validating WalletConnect URI.
mixin WalletConnectUriValidatorMixin {
  bool validateWalletConnectUri(String uri) {
    final sections = uri.split(RegExp('[:,@,?,&]'));

    if (sections.length < 5) return false;

    final protocol = sections[0];
    final topic = sections[1];
    final version = sections[2];
    final bridge = sections[3];
    final key = sections[4];

    return [
      _validateProtocol(protocol),
      _validateTopic(topic),
      _validateVersion(version),
      _validateBridge(bridge),
      _validateKey(key),
    ].every(
      (element) => element == true,
    );
  }

  static bool _validateProtocol(String protocol) => protocol == 'wc';

  static bool _validateTopic(String topic) {
    return Uuid.isValidUUID(fromString: topic);
  }

  static bool _validateVersion(String version) {
    try {
      return !int.parse(version).isNegative;
    } catch (_) {
      return false;
    }
  }

  static bool _validateBridge(String bridge) {
    try {
      final val = _param(bridge, 'bridge');
      final decoded = Uri.decodeFull(val);
      return Uri.parse(decoded).host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static bool _validateKey(String key) {
    try {
      final val = _param(key, 'key');
      return hex.decode(val).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static String _param(String param, String key) {
    final p = param.split('=');
    if (p.length == 1) throw const FormatException('invalid length');
    if (p[0] != key) throw const FormatException('invalid key name');
    return p[1];
  }
}
