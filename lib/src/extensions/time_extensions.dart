extension NDurationExtensions on Duration {
  String get stringify {
    final content = <String>[];

    plural(int value) => value == 1 ? '' : 's';
    addValue(int value, String valueName) => content.add('$value $valueName${plural(value)}');

    final days = inDays;
    final hours = inHours % 24;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    if (days > 0) addValue(days, 'dia');
    if (hours > 0) addValue(hours, 'hora');
    if (minutes > 0) addValue(minutes, 'minuto');
    if (seconds > 0) addValue(seconds, 'segundo');

    return content.join(', ');
  }
}
