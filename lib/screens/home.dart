import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import '../widgets/camera_preview.dart';
import '../widgets/upload_image.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool loading = true;

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        loading = false;
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const Icon(Icons.arrow_back_ios),
      title: const Text("Draggable Home"),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      headerWidget:AnimatedSwitcher(
        switchInCurve: Curves.elasticOut,
        switchOutCurve: Curves.ease,
        reverseDuration: const Duration(milliseconds: 200),
        duration: const Duration(milliseconds: 1200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: loading
            ? const CircularProgressIndicator.adaptive()
            :  headerWidget(context),
      ),
      headerBottomBar: headerBottomBarWidget(),
      body:  [

        SelectImage(loading:loading),
      ],
      fullyStretchable: false,
      expandedBody:  const CameraPreview(),
      backgroundColor: Colors.white,
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Image.asset(
      "assets/brain chemistry-pana.png",
      fit: BoxFit.cover,
    );
  }

  ListView listView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: Colors.white70,
        child: ListTile(
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: const Text("Title"),
          subtitle: const Text("Subtitle"),
        ),
      ),
    );
  }
}