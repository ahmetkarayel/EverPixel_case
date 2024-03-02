enum EnumFilters{
  grayscale,
  sepia,
  sketch,
  pixelate,
  none
}

extension EnumFiltersHelper on EnumFilters{
  String get title{
    switch (this) {
      case EnumFilters.grayscale:
        return "Grayscale";
      case EnumFilters.sepia:
        return "Sepia";
      case EnumFilters.sketch:
        return "Sketch";
      case EnumFilters.pixelate:
        return "Pixelate";
      case EnumFilters.none:
      return "";
    }
  }
}