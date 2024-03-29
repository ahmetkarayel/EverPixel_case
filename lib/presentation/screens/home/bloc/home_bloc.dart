import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:everpixel_case/domain/models/enum_filters.dart';
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
    on<EventHomeApproveChanges>(_approveChanges);
    on<EventHomeAddFilter>(_addFilter);
    on<EventHomeApproveFilter>(_approveFilter);
    on<EventHomeRemoveFilter>(_removeFilter);
    on<EventHomeUndo>(_handleUndo);
    on<EventHomeRedo>(_handleRedo);
  }

  img.Image? originalImage;
  img.Image? clonedImage;
  ui.Image? uiImage;
  double? brightness = 1.0;
  double? contrast = 1.0;
  double? saturation = 1.0;
  EnumFilters selectedFilter = EnumFilters.none;

  List<img.Image> undoStack = [];
  List<img.Image> redoStack = [];

  Future<FutureOr<void>> _getPhoto(EventHomeSelectPhoto event, Emitter<HomeState> emit) async {
    final pickedFile = await ImagePicker().pickImage(source: event.source);
    if (pickedFile!=null) {
      var pickedImage = File(pickedFile.path);
      originalImage = img.decodeImage(pickedImage.readAsBytesSync());
      clonedImage = img.copyResize(originalImage!, width: originalImage!.width, height: originalImage!.height);
      redoStack.add(clonedImage!);
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
    if (selectedFilter == EnumFilters.none) {
        await _updateImage();
    } 

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

  Future<FutureOr<void>> _approveChanges(EventHomeApproveChanges event, Emitter<HomeState> emit) async {
    clonedImage = await ImageHelper.convertFlutterUiToImage(uiImage!);
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
    redoStack.add(clonedImage!);
    if (undoStack.isNotEmpty) {
      undoStack.clear();
    }
    emit(StateHomeEditedImage(uiImage, type: event.type));
  }
  Future<FutureOr<void>> _addFilter(EventHomeAddFilter event, Emitter<HomeState> emit) async {
    selectedFilter = event.type;
    await _updateFilteredImage(event.type); 
    emit(StateHomeEditedImage(uiImage));
  }

  Future<void> _updateFilteredImage(EnumFilters filterType) async {
    var lastUi = await ImageHelper.convertFlutterUiToImage(uiImage!);
    final processedImage = ImageHelper.addFilter(lastUi, filterType);
    uiImage = await ImageHelper.convertImageToFlutterUi(processedImage);
  }

  Future<void> _updateImage() async {
    final processedImage = ImageHelper.processImage(clonedImage!, brightness: brightness, contrast: contrast, saturation: saturation);
    uiImage = await ImageHelper.convertImageToFlutterUi(processedImage);
  }

  Future<FutureOr<void>> _approveFilter(EventHomeApproveFilter event, Emitter<HomeState> emit) async {
    clonedImage = await ImageHelper.convertFlutterUiToImage(uiImage!);
    redoStack.add(clonedImage!);
    if (undoStack.isNotEmpty) {
      undoStack.clear();
    }
    selectedFilter = EnumFilters.none;
    emit(StateHomeEditedImage(uiImage, reset: true));
  }

  Future<FutureOr<void>> _removeFilter(EventHomeRemoveFilter event, Emitter<HomeState> emit) async {
    selectedFilter = EnumFilters.none;
    uiImage = await ImageHelper.convertImageToFlutterUi(clonedImage!);
    emit(StateHomeEditedImage(uiImage, reset: true));
  }

  Future<FutureOr<void>> _handleUndo(EventHomeUndo event, Emitter<HomeState> emit) async {
    var x = redoStack.removeLast();
    undoStack.add(x);
    clonedImage = redoStack.last;
    uiImage = await ImageHelper.convertImageToFlutterUi(clonedImage!);
    emit(StateHomeEditedImage(uiImage));
  }

  FutureOr<void> _handleRedo(EventHomeRedo event, Emitter<HomeState> emit) async{
    var x = undoStack.removeLast();
    redoStack.add(x);
    clonedImage = redoStack.last;
    uiImage = await ImageHelper.convertImageToFlutterUi(clonedImage!);
    emit(StateHomeEditedImage(uiImage));
  }
}
