import 'package:core_resources/core_resources.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  Widget? title,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDialog<DateTime>(
    context: context,
    useRootNavigator: false,
    builder: (context) => DateTimePickerDialog(
      title: title,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class DateTimePickerDialog extends HookWidget {
  final Widget? title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DateTimePickerDialog({
    this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    super.key,
  }) : assert(
         !lastDate.isBefore(firstDate),
         'lastDate $lastDate must be on or after firstDate $firstDate.',
       );

  @override
  Widget build(BuildContext context) {
    final initial = useMemoized(() => _clampDateTime(initialDate, firstDate, lastDate));
    final date = useState(_dateOnly(initial));
    final hour = useState(initial.hour);
    final minute = useState(initial.minute);
    final hourController = useMemoized(
      () => FixedExtentScrollController(initialItem: initial.hour),
    );
    final minuteController = useMemoized(
      () => FixedExtentScrollController(initialItem: initial.minute),
    );
    useEffect(() {
      return () {
        hourController.dispose();
        minuteController.dispose();
      };
    }, [hourController, minuteController]);

    final localizations = MaterialLocalizations.of(context);
    final selectedDateTime = _clampDateTime(
      DateTime(date.value.year, date.value.month, date.value.day, hour.value, minute.value),
      firstDate,
      lastDate,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 280,
          maxWidth: 360,
          maxHeight: MediaQuery.sizeOf(context).height - 32,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title case final title?)
                Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: title),
              CalendarDatePicker(
                initialDate: date.value,
                firstDate: _dateOnly(firstDate),
                lastDate: _dateOnly(lastDate),
                onDateChanged: (value) => date.value = value,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
                  child: _HourMinutePicker(
                    hourController: hourController,
                    minuteController: minuteController,
                    onHourChanged: (value) => hour.value = value,
                    onMinuteChanged: (value) => minute.value = value,
                  ),
                ),
              ),
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localizations.cancelButtonLabel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, selectedDateTime),
                    child: Text(localizations.okButtonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HourMinutePicker extends StatelessWidget {
  final FixedExtentScrollController hourController;
  final FixedExtentScrollController minuteController;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const _HourMinutePicker({
    required this.hourController,
    required this.minuteController,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TimePickerTheme.of(context).hourMinuteTextStyle ?? Theme.of(context).textTheme.titleMedium;

    return DefaultTextStyle.merge(
      style: textStyle,
      child: Row(
        children: [
          Expanded(
            child: _LoopingDigitPicker(
              controller: hourController,
              itemCount: 24,
              onChanged: onHourChanged,
            ),
          ),
          Expanded(
            child: _LoopingDigitPicker(
              controller: minuteController,
              itemCount: 60,
              onChanged: onMinuteChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoopingDigitPicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onChanged;

  const _LoopingDigitPicker({
    required this.controller,
    required this.itemCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 40,
      diameterRatio: 2,
      squeeze: 1,
      magnification: 1.1,
      looping: true,
      onSelectedItemChanged: (index) => onChanged(index % itemCount),
      children: [
        for (var value = 0; value < itemCount; value++)
          Center(child: Text(value.toString().padLeft(2, '0'))),
      ],
    );
  }
}

DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

DateTime _clampDateTime(DateTime value, DateTime first, DateTime last) {
  final selected = DateTime(value.year, value.month, value.day, value.hour, value.minute);
  if (selected.isBefore(first)) {
    return DateTime(first.year, first.month, first.day, first.hour, first.minute);
  }
  if (selected.isAfter(last)) {
    return DateTime(last.year, last.month, last.day, last.hour, last.minute);
  }
  return selected;
}
