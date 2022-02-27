import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/presentation/onboarding.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/widgets/gap.dart';
import 'package:ourpass/core/widgets/state.dart';
import 'package:ourpass/feature/authentication/provider/auth_provider.dart';
import 'package:ourpass/feature/weight_tracker/presentation/add_entry.dart';
import 'package:ourpass/feature/weight_tracker/presentation/widgets/list_header.dart';
import 'package:ourpass/feature/weight_tracker/presentation/widgets/list_item.dart';
import 'package:ourpass/feature/weight_tracker/provider/weight_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeightDataProvider _provider;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _provider = context.read<WeightDataProvider>();
      _provider.watchWeightEntries();
    });
  }

  @override
  void dispose() {
    _provider.unwatchWeightEntries();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<WeightDataProvider>();
    final asyncValueOfWeightEntries = _provider.asyncValueOfWeightEntries;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ourpass",
          style: context.textTheme.subtitle1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Insets.md),
            child: Center(
              child: Text(
                'sign out',
                style: context.textTheme.caption!
                    .copyWith(color: AppColors.kError),
              ).onTap(() {
                context.read<AuthProvider>().signOut();
                context.pushOff(const OnboardingPage());
              }),
            ),
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => const AddEntryPage(),
          );
        },
        backgroundColor: AppColors.kPrimary,
        child: const Icon(PhosphorIcons.plusLight),
      ),
      body: asyncValueOfWeightEntries.when(
        loading: (_) => const Center(child: Text("Loading...")),
        done: (entries) {
          final metric = _provider.pairOfPercentageChangeAndIncrease();
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              if (entries.isEmpty)
                const SliverFillRemaining(
                  child: NoDataOrError(
                      "No entry, tap the floating button to add a new entry"),
                )
              else
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Insets.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (metric != null)
                              ListHeader(
                                latestEntry: entries.first.value,
                                percentageChangeFromPreviousEntry: metric.left,
                                didIncreaseFromPreviousEntry: metric.right,
                              ),
                            Gap.md,
                            Text(
                              "ENTRIES",
                              style: context.textTheme.caption,
                            ),
                            Gap.md,
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final entry = entries[index];
                                return ListItem(item: entry).onTap(
                                  () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AddEntryPage(
                                      item: entry,
                                    ),
                                  ),
                                );
                              },
                              itemCount: entries.length,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ],
          );
        },
        error: (err) => NoDataOrError(
          err!,
          variant: Variant.error,
        ),
      ),
    );
  }
}
