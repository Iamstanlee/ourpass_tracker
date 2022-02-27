import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:ourpass/core/widgets/button.dart';
import 'package:ourpass/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/feature/authentication/provider/auth_provider.dart';
import 'package:ourpass/feature/weight_tracker/presentation/home.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            const Gap(64),
            const Info(
              'Sign In And Sign Out Anonymously',
              PhosphorIcons.numberOne,
            ),
            const Gap(Insets.lg),
            const Info(
              'Add Entries',
              PhosphorIcons.numberTwo,
            ),
            const Gap(Insets.lg),
            const Info(
              'Edit And Delete Entries',
              PhosphorIcons.numberThree,
            ),
            const Spacer(),
            Button(
              isLoading ? "Please wait..." : "GET STARTED",
              onTap: () async {
                if (!authProvider.isLoading) {
                  final failureOrSuccess =
                      await authProvider.signInAnonymously();
                  failureOrSuccess.fold(
                    (failure) => context.notify(failure.msg),
                    (_) => context.pushOff(const HomePage()),
                  );
                }
              },
            ),
            const Gap(Insets.lg),
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final IconData icon;
  final String title;
  const Info(this.title, this.icon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: IconSizes.lg,
        ),
        Gap.md,
        Expanded(
          child: Text(
            title,
            style: context.textTheme.subtitle1,
          ),
        )
      ],
    );
  }
}
