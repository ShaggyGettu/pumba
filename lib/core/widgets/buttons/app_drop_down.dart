import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDropDown<T> extends ConsumerStatefulWidget {
  final List<T> items;
  final T value;
  final String Function(T) display;
  final void Function(T?) onChanged;

  const AppDropDown({
    super.key,
    required this.items,
    required this.value,
    required this.display,
    required this.onChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppDropDownState<T>();
}

class _AppDropDownState<T> extends ConsumerState<AppDropDown<T>> {
  List<T> get _items => widget.items;
  T get _selectedValue => widget.value;
  String Function(T) get _display => widget.display;
  void Function(T?) get _onChanged => widget.onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      items: _items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(_display(item)),
        );
      }).toList(),
      onChanged: _onChanged,
      value: _selectedValue,
    );
  }
}
