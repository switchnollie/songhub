// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:song_hub/components/spinner.dart';

/// A component to display an auto completing text field
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 6.0),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onBackground)),
        ),
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            autofocus: false,
            style: DefaultTextStyle.of(context).style,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
              alignLabelWithHint: true,
              prefixIcon: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
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
          transitionBuilder: (context, suggestionsBox, animationController) =>
              FadeTransition(
            child: suggestionsBox,
            opacity: CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
          ),
          loadingBuilder: (context) => Spinner(),
        ),
      ],
    );
  }
}
