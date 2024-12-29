class ActiveTc {
  static ActiveTc? _instance; //late final ı dene

  static ActiveTc get instance => _instance ??= ActiveTc._();

  ActiveTc._();

  late String activeTc="8920308978";
}
