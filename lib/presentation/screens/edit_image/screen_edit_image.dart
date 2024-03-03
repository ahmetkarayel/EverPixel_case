import 'package:everpixel_case/domain/models/enum_filters.dart';
import 'package:everpixel_case/domain/models/enum_tune.dart';
import 'package:everpixel_case/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';

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

  List<EnumFilters> filters = EnumFilters.values.where((element) => element!=EnumFilters.none).toList(); 

  @override
  void initState() {
    super.initState();
    _uiImage = widget.uiImage;
  }

  void handleUndoRedoButtons(HomeEvent event) {
    if (event is EventHomeUndo) {
      widget.bloc.add(event);
    } else if (event is EventHomeRedo) {
      widget.bloc.add(event);
    }
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
        if (state.reset) {
          _brightness = 1.0;
          _contrast = 1.0;
          _saturation = 1.0;
        }
        _uiImage = state.image;
      });
    }
  }


  _shareButton() {
     var uint8List = img.encodePng(widget.bloc.clonedImage!);
        Share.shareXFiles(
          [
            XFile.fromData(
              uint8List,
              name: 'Image Gallery',
              mimeType: 'image/png',
            ),
          ],
          subject: 'Image Gallery',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fotoğraf Düzenleme"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              _shareButton();
            }, 
            icon: const Icon(Icons.share_rounded))
        ],
    ),
      body: BlocListener(
        listener: _handleBlocStates,
        bloc: widget.bloc,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: (widget.bloc.redoStack.length>1) ? 1 : 0.2,
                      child: GestureDetector(
                        onTap: (widget.bloc.redoStack.isNotEmpty) ? ()=> handleUndoRedoButtons(EventHomeUndo()) : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle
                          ),
                          child: const Center(child: Icon(Icons.undo_outlined, size: 32,))    
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:8.0),
                        child: Center(child: RawImage(image: _uiImage,height: 300,)),
                      ),
                    ),
                     Opacity(
                      opacity: (widget.bloc.undoStack.isNotEmpty) ? 1 : 0.2,
                      child: GestureDetector(
                        onTap: (widget.bloc.undoStack.isNotEmpty) ? ()=>handleUndoRedoButtons(EventHomeRedo()) : null,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle
                          ),
                          child: const Center(child: Icon(Icons.redo_outlined, size: 32,))    
                        ),
                      ),
                    ), 

                  ],
                ),
                 const SizedBox(height: 16,),
                 _widgetSlider(type: EnumTuneProperties.contrast,defaultValue: _contrast),
                const SizedBox(height: 16,),
                _widgetSlider(type: EnumTuneProperties.saturation,defaultValue: _saturation),
                const SizedBox(height: 16,),
                _widgetSlider(type: EnumTuneProperties.brightness,defaultValue: _brightness),
                const SizedBox(height: 16,),  
                const Text("Filtreler", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),),
                 SizedBox(
                  height: 125,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (context, index){
                      var filter = filters[index];
                      return GestureDetector(
                        onTap: widget.bloc.selectedFilter == EnumFilters.none ? (){
                          widget.bloc.add(EventHomeAddFilter(filter));
                        } : null,
                        child: AnimatedContainer(
                          duration: Durations.medium2,
                          width: 100,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.amber.withOpacity(0.4),
                            border: Border.all(color: filter == widget.bloc.selectedFilter ? Colors.red : Colors.black, width: filter == widget.bloc.selectedFilter ? 2 : 1)
                          ),
                          child: Column(
                            children: [
                              Center(child: Text(filter.title)),
                              const Spacer(),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    widget.bloc.add(EventHomeRemoveFilter());
                                  },
                                  child: const Icon(Icons.cancel_outlined, color: Colors.red,)),
                                const SizedBox(width: 16,),
                                GestureDetector(
                                  onTap: (){
                                    widget.bloc.add(EventHomeApproveFilter());
                                  },
                                  child: const Icon(Icons.done_outline_outlined, color: Colors.green,))
                              ], 
                            ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index)=> const SizedBox(width: 16,),
                    ),
                ) 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetSlider({required EnumTuneProperties type, required double defaultValue}){
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
            onChanged: widget.bloc.selectedFilter == EnumFilters.none ? (value){
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
              
            } : null  
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
              GestureDetector(
                onTap: (){
                  widget.bloc.add(EventHomeApproveChanges(type));
                },
                child: const Icon(Icons.done_outline_outlined, color: Colors.green,))
            ], 
          ),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}