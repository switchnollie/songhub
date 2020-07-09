// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
enum Label {
  Idea,
  VoiceMemo,
  LiveSession,
  DemoTape,
  RoughMix,
  IntermediateMix,
  FinalMix,
  Master
}

/// A structure to hold [Label] to be displayed in this apps recording modals.
extension LabelExtension on Label {
  static String _value(Label val) {
    switch (val) {
      case Label.Idea:
        return "Idea";
      case Label.VoiceMemo:
        return "Voice Memo";
      case Label.LiveSession:
        return "Live Session";
      case Label.DemoTape:
        return "Demo Tape";
      case Label.RoughMix:
        return "Rough Mix";
      case Label.IntermediateMix:
        return "Intermediate Mix";
      case Label.FinalMix:
        return "Final Mix";
      case Label.Master:
        return "Master";
    }
    return "";
  }

  String get value => _value(this);
}

const Map<String, Label> mappedLabels = {
  "Idea": Label.Idea,
  "Voice Memo": Label.VoiceMemo,
  "Live Session": Label.LiveSession,
  "Demo Tape": Label.DemoTape,
  "Rough Mix": Label.RoughMix,
  "Intermediate Mix": Label.IntermediateMix,
  "Final Mix": Label.FinalMix,
  "Master": Label.Master,
};

const List<String> labels = [
  "Idea",
  "Voice Memo",
  "Live Session",
  "Demo Tape",
  "Rough Mix",
  "Intermediate Mix",
  "Final Mix",
  "Master",
];
