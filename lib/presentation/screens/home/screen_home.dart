import 'package:everpixel_case/presentation/screens/edit_image/screen_edit_image.dart';
import 'package:everpixel_case/presentation/screens/home/bloc/home_bloc.dart';
import 'package:everpixel_case/presentation/screens/home/widgets/widget_container_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../helpers/alert_builder.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {

  final HomeBloc _bloc = HomeBloc();
  //ui.Image? _uiImage;
  bool _isDialogOpen = false;

  void _handleBlocStates(BuildContext context, state) {
    if (state is StateHomeHasPhoto) {
      if (_isDialogOpen) {
        Navigator.of(context).pop();
        _isDialogOpen = false;
      }
      //_uiImage = state.image;
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenEditImage(uiImage: state.image,bloc: _bloc,)));
    } else if(state is StateHomeLoadingAlert){
      _isDialogOpen =true;
      AlertBuilder.basicShowProgressDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PixVibe"),centerTitle: true,),
      body: BlocListener(
        bloc: _bloc,
        listener: _handleBlocStates,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetContainerButton(
                title: "Kamera", 
                icon: const Icon(Icons.camera_alt_outlined, size: 56,),
                onTap: (){
                  _bloc.add(EventHomeSelectPhoto(source: ImageSource.camera));
                },
                ),
              const SizedBox(width: 8,),
              WidgetContainerButton(
                title: "Galeri", 
                icon: const Icon(Icons.photo_album_outlined, size: 56,), 
                onTap: (){
                  _bloc.add(EventHomeSelectPhoto(source: ImageSource.gallery));
                },
                )
            ],
          ),
        ),
      ),
    );
  }
}