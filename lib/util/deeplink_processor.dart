


class DeepLinkProcessor {
  final String _baseUrl = 'https://project-url.firebaseapp.com/__/auth/action?';
  final String _schemeAndDomain = 'appscheme://login';

  String? generateAuthUrlFromDeepLink(String deepLink) {
    if (!_isValidDeepLink(deepLink)) {
      return null;
    }

    final paramMap = _extractQueryParameters(_removeSchemeAndDomain(deepLink));
    return _constructAuthUrl(paramMap);
  }

  bool _isValidDeepLink(String? deepLink) {
    return deepLink != null && deepLink.startsWith(_schemeAndDomain);
  }

  String _removeSchemeAndDomain(String deepLink) {
    return deepLink.replaceFirst('$_schemeAndDomain?', '');
  }

  Map<String, String> _extractQueryParameters(String queryString) {
    final params = queryString.split('&');
    final paramMap = <String, String>{};

    for (final param in params) {
      final keyValue = param.split('=');
      if (keyValue.length == 2) {
        paramMap[keyValue[0].trim()] = keyValue[1].trim();
      }
    }
    return paramMap;
  }

  String _constructAuthUrl(Map<String, String> paramMap) {
    final apiKey = _getParameterValue(paramMap, 'apiKey', 'apiKey');
    final oobCode = _getParameterValue(paramMap, 'oobCode', 'oobCode');
    final continueUrl =
        "continueUrl=https://project-url.web.app/app?email=${Uri.encodeComponent(paramMap['email']!)}";

    return '$_baseUrl$apiKey&mode=signIn&$oobCode&$continueUrl&lang=en';
  }

  String _getParameterValue(Map<String, String> paramMap, String key, String param) {
    return paramMap.containsKey(key) ? '$param=${paramMap[key]}' : '';
  }
}
