import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteTextField extends StatelessWidget {
  final SuggestionsCallback onChanged;
  final SuggestionSelectionCallback onSelected;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Function validator;
  final String initialValue;
  final ItemBuilder itemBuilder;
  final String notFoundText;

  AutocompleteTextField({
    this.controller,
    this.label,
    this.onChanged,
    this.onSelected,
    this.hintText,
    this.validator,
    this.initialValue = "",
    this.itemBuilder,
    this.notFoundText = "No Items Found!",
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        autofocus: false,
        style: DefaultTextStyle.of(context).style,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
          alignLabelWithHint: true,
          prefixIcon: Icon(Icons.share),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
              width: 2.0,
            ),
          ),
          hintText: hintText,
        ),
      ),
      itemBuilder: itemBuilder,
      validator: validator,
      errorBuilder: (BuildContext context, Object error) {
        if (error.runtimeType != RangeError) {
          return Text('$error',
              style: TextStyle(color: Theme.of(context).errorColor));
        }
        return null;
      },
      noItemsFoundBuilder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(notFoundText),
      ),
      suggestionsCallback: onChanged,
      onSuggestionSelected: onSelected,
    );
  }
}
