class TestApp {
  static TestApp? _instance;
  static TestApp get instance => TestApp._();
  final bool _isTest = false;

  bool get isTest => _isTest;
  TestApp._();
}
