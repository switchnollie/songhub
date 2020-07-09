// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
/// takes a substring and returns the start and endcode to use in
/// firestory Query filters
List<String> getCodesStartsWith(String startsWithSubstr) {
  final strlength = startsWithSubstr.length;
  final strFrontCode = startsWithSubstr.substring(0, strlength - 1);
  final strEndCode =
      startsWithSubstr.substring(strlength - 1, startsWithSubstr.length);

  final startcode = startsWithSubstr;
  final endcode =
      strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);

  return [startcode, endcode];
}
