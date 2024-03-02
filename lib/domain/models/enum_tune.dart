enum EnumTuneProperties{
  contrast,
  saturation,
  brightness
}

extension EnumTunePropertiesHelper on EnumTuneProperties{
  String get title{
    switch (this) {
      case EnumTuneProperties.contrast:
        return "Contrast";
      case EnumTuneProperties.saturation:
        return "Saturation";
      case EnumTuneProperties.brightness:
        return "Brightness";
    }
  }
}