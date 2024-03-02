import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';



class SelectImage extends StatefulWidget {
   SelectImage({ Key? key, required this.loading}) : super(key: key);
  final bool loading;

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> with SingleTickerProviderStateMixin {
  String _image = 'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    setState(() {
      _platformFile = null;
      loadingController.reset();


    });
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']
    );

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() { setState(() {}); });

    super.initState();
  }

  //////////////////////////////////
  /// @theflutterlover on Instagram
  ///
  /// https://afgprogrammer.com
  //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[

          const SizedBox(height: 50,),
          Text('Upload your file', style: TextStyle(fontSize: 25, color: Colors.grey.shade800, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          Text('File should be jpg, png', style: TextStyle(fontSize: 15, color: Colors.grey.shade500),),
          const SizedBox(height: 20,),
          AnimatedSwitcher(
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.ease,
            reverseDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: widget.loading
                ? const CircularProgressIndicator.adaptive()
                :  GestureDetector(
              onTap: selectFile,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.folder_open, color: Colors.blue, size: 40,),
                          const SizedBox(height: 15,),
                          Text('Select your file', style: TextStyle(fontSize: 15, color: Colors.grey.shade400),),
                        ],
                      ),
                    ),
                  )
              ),
            ),
          )
          ,
          _platformFile != null
              ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected File',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15, ),),
                  const SizedBox(height: 10,),
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 2,
                            )
                          ]
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_file!, width: 70,)
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_platformFile!.name,
                                  style: const TextStyle(fontSize: 13, color: Colors.black),),
                                const SizedBox(height: 5,),
                                Text('${(_platformFile!.size / 1024).ceil()} KB',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                                ),
                                const SizedBox(height: 5,),
                                Container(
                                    height: 5,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue.shade50,
                                    ),
                                    child: LinearProgressIndicator(
                                      value: loadingController.value,
                                    )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                        ],
                      )
                  ),
                  const SizedBox(height: 20,),

                ],
              ))
              : Container(),

          AnimatedSwitcher(
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.ease,
            reverseDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: _file != null && loadingController.isCompleted && _platformFile != null
                ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Result',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15, ),),
                  const SizedBox(height: 10,),
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              spreadRadius: 2,
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_file!, width: double.infinity, fit: BoxFit.cover,)
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: (){}, child: const Text('Predict'),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                                ),
                              ),
                              ElevatedButton(onPressed: (){
                                setState(() {
                                  _file = null;
                                  _platformFile = null;
                                });
                              }, child: const Text('Clear'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 50),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),

                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: 20,),

                ],
              ),
            )
                : Text(""),
          ),


        ],
      ),
    );
  }
}