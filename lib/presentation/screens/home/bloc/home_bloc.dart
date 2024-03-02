import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:everpixel_case/domain/models/enum_tune.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../helpers/image_helper.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<EventHomeSelectPhoto>(_getPhoto);
    on<EventHomeAdjustColor>(_adjustColor);
    on<EventHomeSetDefaultValue>(_setDefaultValue);
  }

  img.Image? originalImage;
  img.Image? clonedImage;
  ui.Image? uiImage;
  double? brightness = 1.0;
  double? contrast = 1.0;
  double? saturation = 1.0;

  Future<FutureOr<void>> _getPhoto(EventHomeSelectPhoto event, Emitter<HomeState> emit) async {
    final pickedFile = await ImagePicker().pickImage(source: event.source);
    if (pickedFile!=null) {
      var pickedImage = File(pickedFile.path);
      originalImage = img.decodeImage(pickedImage.readAsBytesSync());
      clonedImage = img.copyResize(originalImage!, width: originalImage!.width, height: originalImage!.height);
      emit(StateHomeLoadingAlert());
      uiImage = await ImageHelper.convertImageToFlutterUi(clonedImage!);
      emit(StateHomeHasPhoto(image: uiImage));
    }
  }

  Future<FutureOr<void>> _adjustColor(EventHomeAdjustColor event, Emitter<HomeState> emit) async {
    switch(event.type) {
      case EnumTuneProperties.brightness:
        brightness = event.value;
        break;
      case EnumTuneProperties.contrast:
        contrast = event.value;
        break;
      case EnumTuneProperties.saturation:
        saturation = event.value;
        break;
  }
/*     final processedImage = ImageHelper.processImage(clonedImage!, brightness: brightness, contrast: contrast, saturation: saturation);
    uiImage = await ImageHelper.convertImageToFlutterUi(processedImage); */
    await _updateImage();
    emit(StateHomeEditedImage(uiImage));
  }

  Future<FutureOr<void>> _setDefaultValue(EventHomeSetDefaultValue event, Emitter<HomeState> emit) async {
    switch(event.type) {
      case EnumTuneProperties.brightness:
        brightness = 1.0;
        break;
      case EnumTuneProperties.contrast:
        contrast = 1.0;
        break;
      case EnumTuneProperties.saturation:
        saturation = 1.0;
        break;
    }
    await _updateImage();
    emit(StateHomeEditedImage(uiImage,type: event.type));
  }
  
  Future<void> _updateImage() async {
    final processedImage = ImageHelper.processImage(clonedImage!, brightness: brightness, contrast: contrast, saturation: saturation);
    uiImage = await ImageHelper.convertImageToFlutterUi(processedImage);
  }
}
