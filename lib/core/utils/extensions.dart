import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/failure/exception.dart';
import 'package:ourpass/core/utils/router.dart';
import 'package:ourpass/feature/authentication/provider/auth_provider.dart';
import 'package:ourpass/injector.dart';

extension NumberExtension on num {
  /// interpolate a value from one range to another
  double normalize(
    num min,
    num max, {
    lowerBound = 0,
    upperBound = 100,
  }) {
    if (this == 0) return 0;
    return (upperBound - lowerBound) * ((this - min) / (max - min)) +
        lowerBound;
  }
}

extension StringExtension on String {
  int toInt() => int.parse(this);
  double toDouble() => double.parse(this);
  DateTime toDateTime() => DateTime.parse(this);

  String pluralize(int len) {
    if (isEmpty) return "";
    if (len == 1) return this;
    if (this[length - 1] == "y") return "${substring(0, length - 1)}ies";
    return "${this}s";
  }

  String relativeToNow() {
    final thisInstant = DateTime.now();
    final diff = thisInstant.difference(toDateTime());

    if ((diff.inDays / 365).floor() >= 2) {
      return '${(diff.inDays / 365).floor()} years ago';
    } else if ((diff.inDays / 365).floor() >= 1) {
      return 'Last year';
    } else if ((diff.inDays / 30).floor() >= 2) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else if ((diff.inDays / 30).floor() >= 1) {
      return 'Last month';
    } else if ((diff.inDays / 7).floor() >= 2) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if ((diff.inDays / 7).floor() >= 1) {
      return 'Last week';
    } else if (diff.inDays >= 2) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays >= 1) {
      return 'Yesterday';
    } else if (diff.inHours >= 2) {
      return '${diff.inHours} hours ago';
    } else if (diff.inHours >= 1) {
      return '1 hour ago';
    } else if (diff.inMinutes >= 2) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inMinutes >= 1) {
      return '1 minute ago';
    } else if (diff.inSeconds >= 3) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

extension ContextExtension on BuildContext {
  double getHeight([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.height * factor;
  }

  double getWidth([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.width * factor;
  }

  double get height => getHeight();
  double get width => getWidth();

  TextTheme get textTheme => Theme.of(this).textTheme;

  Future<T?> push<T>(Widget page) =>
      Navigator.push<T>(this, PageRouter.fadeThrough(() => page));

  Future<T?> pushOff<T>(Widget page) => Navigator.pushAndRemoveUntil<T>(
      this, PageRouter.fadeThrough(() => page), (_) => false);

  Future<bool> pop<T>([T? result]) => Navigator.maybePop(this, result);

  void notify(String msg, [Color? color]) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          msg,
        ),
        backgroundColor: color ?? AppColors.kError,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: Insets.md,
          right: Insets.md,
          bottom: getHeight(0.75),
        ),
      ),
    );
  }
}

extension WidgetExtension on Widget {
  Widget onTap(VoidCallback action, {bool opaque = true}) {
    return GestureDetector(
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      onTap: action,
      child: this,
    );
  }
}

extension FirestoreExtension on FirebaseFirestore {
  CollectionReference<Map<String, dynamic>> userEntryCollection() {
    final user = getIt<AuthProvider>().user;
    if (user.isValid) {
      return collection("users").doc(user.uid).collection("entries");
    }
    throw InvalidArgException();
  }
}
