import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/widgets/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ListHeader extends StatelessWidget {
  final double latestEntry;
  final double percentageChangeFromPreviousEntry;
  final bool didIncreaseFromPreviousEntry;
  const ListHeader({
    required this.latestEntry,
    required this.percentageChangeFromPreviousEntry,
    required this.didIncreaseFromPreviousEntry,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color =
        didIncreaseFromPreviousEntry ? AppColors.kError : Colors.green;
    final iconData = didIncreaseFromPreviousEntry
        ? PhosphorIcons.arrowUp
        : PhosphorIcons.arrowDown;

    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$latestEntry kg",
                style: context.textTheme.headline4!.copyWith(
                  color: color,
                  fontSize: FontSizes.s24,
                ),
              ),
              Gap.sm,
              Container(
                padding: const EdgeInsets.all(2),
                color: color.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      size: 14,
                      color: color,
                    ),
                    const Gap(2),
                    Text(
                      '$percentageChangeFromPreviousEntry%',
                      style: context.textTheme.caption!.copyWith(color: color),
                    )
                  ],
                ),
              )
            ],
          ),
          Gap.sm,
          Text(
            'LATEST RECORD',
            style: context.textTheme.caption,
          )
        ],
      ),
    );
  }
}
