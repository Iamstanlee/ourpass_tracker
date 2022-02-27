import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/widgets/gap.dart';
import 'package:ourpass/feature/weight_tracker/model/weight.dart';

class ListItem extends StatelessWidget {
  final WeightModel item;

  const ListItem({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(
                height: 8,
                width: 8,
                child: ColoredBox(
                  color: AppColors.kPrimary,
                ),
              ),
              Gap.md,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.value} kg",
                    style: context.textTheme.bodyText1!
                        .copyWith(fontSize: FontSizes.s16),
                  ),
                  Text(
                    item.updatedAt.relativeToNow(),
                    style: context.textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
