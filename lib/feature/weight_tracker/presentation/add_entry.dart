import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/widgets/gap.dart';
import 'package:ourpass/feature/weight_tracker/model/weight.dart';
import 'package:ourpass/feature/weight_tracker/presentation/widgets/onscreen_keyboard.dart';
import 'package:ourpass/feature/weight_tracker/provider/weight_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class AddEntryPage extends StatefulWidget {
  final WeightModel? item;
  const AddEntryPage({this.item, Key? key}) : super(key: key);

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double value = 0;
  late WeightModel? editItem;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          microseconds: 2000,
        ));
    _animation = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceIn,
      ),
    );
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    editItem = widget.item;
    if (editItem != null) {
      setState(() {
        value = editItem!.value;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeightDataProvider>();
    final isLoading = provider.isLoading;
    return SizedBox(
      height: context.getHeight(0.7),
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Corners.lgRadius,
          topRight: Corners.lgRadius,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          PhosphorIcons.x,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        (editItem != null) ? 'Edit Entry' : 'Add Entry',
                        style: context.textTheme.subtitle1,
                      ),
                      if (editItem != null)
                        Icon(PhosphorIcons.trashSimpleFill,
                                color: AppColors.kError)
                            .onTap(() async {
                          final failureOrSuccess = await provider
                              .updateOrDeleteEntry(editItem!, delete: true);
                          failureOrSuccess.fold(
                            (failure) => context.notify(failure.msg),
                            (_) {
                              context.notify(
                                  "Record Deleted", AppColors.kPrimary);
                              context.pop();
                            },
                          );
                        })
                    ],
                  ),
                  Gap.md,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: Text(
                          value.toString(),
                          style: context.textTheme.headline3!
                              .copyWith(color: AppColors.kDark),
                        ),
                      ),
                    ],
                  ),
                  Gap.lg,
                ],
              ),
            ),
            const Spacer(),
            OnScreenKeyboard(
              initialValue: editItem?.value,
              onChange: (_value) {
                setState(() {
                  _controller.forward();
                  value = _value.toStringAsFixed(2).toDouble();
                });
              },
              onEnter: () async {
                if (!isLoading) {
                  final thisInstant = DateTime.now();
                  final weightEntry = editItem ??
                      WeightModel(
                        value: value,
                        id: thisInstant.microsecondsSinceEpoch.toString(),
                        createdAt: thisInstant.toIso8601String(),
                        updatedAt: thisInstant.toIso8601String(),
                      );

                  var future = provider.createEntry(
                    weightEntry,
                  );

                  if (editItem != null) {
                    future = provider.updateOrDeleteEntry(
                      editItem!.copyWith(
                        value: value,
                        updatedAt: thisInstant.toIso8601String(),
                      ),
                    );
                  }
                  final failureOrSuccess = await future;
                  failureOrSuccess.fold(
                    (failure) => context.notify(failure.msg),
                    (_) {
                      context.notify("Record Updated", AppColors.kPrimary);
                      context.pop();
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
