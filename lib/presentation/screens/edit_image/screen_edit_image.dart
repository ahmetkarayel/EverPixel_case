import 'package:everpixel_case/domain/models/enum_tune.dart';
import 'package:everpixel_case/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class ScreenEditImage extends StatefulWidget {
  final ui.Image? uiImage;
  final HomeBloc bloc;
  const ScreenEditImage({super.key, required this.uiImage, required this.bloc});

  @override
  State<ScreenEditImage> createState() => _ScreenEditImageState();
}

class _ScreenEditImageState extends State<ScreenEditImage> {

/// [contrast] increases (> 1) / decreases (< 1) the contrast of the image by
/// pushing colors away/toward neutral gray, where at 0.0 the image is entirely
/// neutral gray (0 contrast), 1.0, the image is not adjusted and > 1.0 the
/// image increases contrast.
  double _contrast = 1.0;

  /// [saturation] increases (> 1) / decreases (< 1) the saturation of the image
  /// by pushing colors away/toward their grayscale value, where 0.0 is grayscale
  /// and 1.0 is the original image, and > 1.0 the image becomes more saturated.
  double _saturation = 1.0;

  /// [brightness] is a constant scalar of the image colors. At 0 the image
  /// is black, 1.0 unmodified, and > 1.0 the image becomes brighter.
  double _brightness = 1.0;
  ui.Image? _uiImage;

  @override
  void initState() {
    super.initState();
    _uiImage = widget.uiImage;
  }

  void _handleBlocStates(BuildContext context, state) {
    if (state is StateHomeEditedImage) {
      setState(() {
        if (state.type !=null) {
          switch(state.type) {
            case EnumTuneProperties.brightness:
              _brightness = 1.0;
              break;
            case EnumTuneProperties.contrast:
              _contrast = 1.0;
              break;
            case EnumTuneProperties.saturation:
              _saturation = 1.0;
              break;
            case null:
          }
        }
        _uiImage = state.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fotoğraf Düzenleme"),centerTitle: true,),
      body: BlocListener(
        listener: _handleBlocStates,
        bloc: widget.bloc,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(child: RawImage(image: _uiImage, height: 300,)),
                const SizedBox(height: 16,),
                _widgetSlider(type: EnumTuneProperties.contrast,defaultValue: _contrast),
                const SizedBox(height: 16,),
                _widgetSlider(type: EnumTuneProperties.saturation,defaultValue: _saturation),
                const SizedBox(height: 16,),
                _widgetSlider(type: EnumTuneProperties.brightness,defaultValue: _brightness),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetSlider({required EnumTuneProperties type, required double defaultValue}){
    debugPrint("-->> widgetSlider type: $type - value: $defaultValue");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(),
        color: Colors.amber.withOpacity(0.1)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(type.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          Slider.adaptive(
            min: 0,
            max: 2,
            divisions: 10,
            value: defaultValue, 
            label: defaultValue.toString(),
            onChanged: (value){
              switch(type) {
                case EnumTuneProperties.contrast:
                  _contrast = value;
                  break;
                case EnumTuneProperties.saturation:
                  _saturation = value;
                  break;
                case EnumTuneProperties.brightness:
                  _brightness = value;
                  break;
              }
              setState(() {});
              widget.bloc.add(EventHomeAdjustColor(type: type, value: value));
            }
            ),
          const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  widget.bloc.add(EventHomeSetDefaultValue(type));
                },
                child: const Icon(Icons.cancel_outlined, color: Colors.red,)),
              const SizedBox(width: 16,),
              const Icon(Icons.done_outline_outlined, color: Colors.green,)
            ], 
          ),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}