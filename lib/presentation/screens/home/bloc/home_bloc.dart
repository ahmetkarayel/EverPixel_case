import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
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
  }

  img.Image? originalImage;
  img.Image? clonedImage;

  Future<FutureOr<void>> _getPhoto(EventHomeSelectPhoto event, Emitter<HomeState> emit) async {
    var uiImage;
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
}
