import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/utils/extensions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OnScreenKeyboard extends StatefulWidget {
  final ValueChanged<double> onChange;
  final Function onEnter;
  final double? initialValue;
  const OnScreenKeyboard(
      {required this.onChange,
      required this.onEnter,
      this.initialValue,
      Key? key})
      : super(key: key);

  @override
  _OnScreenKeyboardState createState() => _OnScreenKeyboardState();
}

class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  final double kPadHeight = 80;
  String editValue = "";

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      editValue = widget.initialValue.toString();
    }
  }

  void _onEnter() {
    if (editValue.isNotEmpty) widget.onEnter();
  }

  void _onChange(_Key key) {
    String value = key.value;
    if (value == 'delete') {
      if (editValue.isNotEmpty) {
        editValue = editValue.substring(0, editValue.length - 1);
        widget.onChange(editValue.isEmpty ? 0 : editValue.toDouble());
      }
      return;
    }
    if (_canEditText(editValue, value) &&
        !_hasReachedMaxValue(
          editValue,
          value,
        )) {
      editValue += value;
      return widget.onChange(editValue.toDouble());
    }
  }

  bool _hasReachedMaxValue(String text, String value) {
    if (text.isEmpty || value == '.') return false;
    final _amount = text + value;
    return !(_amount.toDouble() < 1000);
  }

  bool _canEditText(String text, String value) {
    final dotChar = value == '.';
    // text cannot start with a leading dot
    if (text.isEmpty && dotChar) return false;
    // cannot add zeros to empty text
    if (text.isEmpty && value.toInt() == 0) return false;
    // cannot add another dot if a dot already exist
    if (text.contains(".") && dotChar) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kPadHeight * 4,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ..._numberKeys
                          .map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: e
                                    .map(
                                      (key) => Expanded(
                                        child: SizedBox(
                                          height: kPadHeight,
                                          child: Keypad(
                                            key,
                                            onTap: () => _onChange(key),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ))
                          .toList(),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: kPadHeight,
                              child: Keypad(
                                _Key("0"),
                                onTap: () => _onChange(_Key("0")),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: kPadHeight,
                            width: context.getWidth(0.224),
                            child: Keypad(
                              _Key("."),
                              onTap: () => _onChange(_Key(".")),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: context.getWidth(0.33),
                  child: Column(
                    children: [
                      SizedBox(
                        height: kPadHeight,
                        child: Keypad(
                          _Key("delete"),
                          onTap: () => _onChange(_Key("delete")),
                          color: AppColors.kGrey200,
                          child: const Icon(
                            PhosphorIcons.backspace,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Keypad(
                          _Key("enter"),
                          onTap: () => _onEnter(),
                          color: AppColors.kPrimary,
                          child: const Icon(
                            PhosphorIcons.arrowElbowDownLeftThin,
                            size: IconSizes.lg,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Keypad extends StatelessWidget {
  final _Key _key;
  final Color? color;
  final Widget? child;
  final Function? onTap;
  const Keypad(this._key, {this.color, this.child, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap!(),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          border: Border.all(
            color: AppColors.kGrey,
            width: .9,
          ),
        ),
        child: Center(
          child: child ?? Text(_key.value, style: context.textTheme.subtitle1),
        ),
      ),
    );
  }
}

class _Key {
  String value;
  _Key(this.value);
}

List<List<_Key>> _numberKeys = [
  [
    _Key("1"),
    _Key("2"),
    _Key("3"),
  ],
  [
    _Key("4"),
    _Key("5"),
    _Key("6"),
  ],
  [
    _Key("7"),
    _Key("8"),
    _Key("9"),
  ]
];
