
import 'package:cheque_stash/util/constants.dart';
import 'package:flutter/material.dart';

class RecurringDateChooser extends StatefulWidget {

  final Function(DateTime date) onChange;

  const RecurringDateChooser({Key? key, required this.onChange}) : super(key: key);

  @override
  State<RecurringDateChooser> createState() => _RecurringDateChooserState();
}

class _RecurringDateChooserState extends State<RecurringDateChooser> {

  DateTime? date;
  final now = DateTime.now();
  final dates = List.generate(31, ((index) => index + 1));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Wrap(
          alignment: WrapAlignment.center,
          children: dates.map((e){
            return ChoiceChip(
              onSelected: (_){
                setState(() {
                  date = DateTime(2000, 12, e);
                });
                widget.onChange(date!);
              },
              selected: date?.day == e,
              label: Text(e.toString()),
            );
          }).toList(),
        ),

        AnimatedSwitcher(
          switchInCurve: Constants.DEFAULT_CURVE,
          switchOutCurve: Constants.DEFAULT_CURVE,
          duration: Constants.DEFAULT_DURATION,
          transitionBuilder: (child, animation){
            return SizeTransition(
              axisAlignment: 1,
              sizeFactor: animation,
              child: child
            );
          },
          child: date != null && date!.day > 28 ? Padding(
            padding: const EdgeInsets.only(
              left: Constants.DEFAULT_PADDING,
              right: Constants.DEFAULT_PADDING,
              top: Constants.SMALL_PADDING,
            ),
            child: Text(
              'Warning!\nwhen selecting the ${date!.day}th day of the month, the last day of the month will be used for months without this day',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ) : const SizedBox.shrink(),
        ),
      ],
    );
  }
}