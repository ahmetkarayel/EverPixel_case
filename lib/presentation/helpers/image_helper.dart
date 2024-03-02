import 'dart:ui' as ui;
import 'package:everpixel_case/domain/models/enum_filters.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';

class ImageHelper{
  static Future<ui.Image> convertImageToFlutterUi(img.Image image) async {
    if (image.format != img.Format.uint8 || image.numChannels != 4) {
      final cmd = img.Command()
        ..image(image)
        ..convert(format: img.Format.uint8, numChannels: 4);
      final rgba8 = await cmd.getImageThread();
      if (rgba8 != null) {
        image = rgba8;
      }
    }

    ui.ImmutableBuffer buffer = await
      ui.ImmutableBuffer.fromUint8List(image.toUint8List());

    ui.ImageDescriptor id = ui.ImageDescriptor.raw(
      buffer,
      height: image.height,
      width: image.width,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    ui.Codec codec = await id.instantiateCodec(
      targetHeight: image.height,
      targetWidth: image.width,
    );

    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image uiImage = fi.image;

    return uiImage;
  }

  static Future<img.Image> convertFlutterUiToImage(ui.Image uiImage) async {
    final uiBytes = await uiImage.toByteData();

    final image = img.Image.fromBytes(width: uiImage.width, height: uiImage.height,
        bytes: uiBytes!.buffer,
        numChannels: 4);

    return image;
  } 

  static img.Image processImage(img.Image image, {double? brightness, double? contrast, double? saturation}) {
    img.Image clonedImage = img.copyResize(image, width: image.width, height: image.height);
    clonedImage = img.adjustColor(clonedImage, brightness: brightness, contrast: contrast, saturation: saturation);
    return clonedImage;
  }

  static img.Image addFilter(img.Image image, EnumFilters filterType) {
    img.Image clonedImage = img.copyResize(image, width: image.width, height: image.height);
    switch (filterType) {
      case EnumFilters.grayscale:
        clonedImage = img.grayscale(clonedImage);
      case EnumFilters.pixelate:
        clonedImage = img.pixelate(clonedImage, size: 16);
      case EnumFilters.sepia:
        clonedImage = img.sepia(clonedImage);
      case EnumFilters.sketch:
        clonedImage = img.sketch(clonedImage);
      case EnumFilters.none:
        
    }
    return clonedImage;
  }
}