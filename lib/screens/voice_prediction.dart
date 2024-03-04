import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/voice_inputs.dart';

class VoicePrediction extends StatefulWidget {
  const VoicePrediction({Key? key}) : super(key: key);

  @override
  State<VoicePrediction> createState() => _VoicePredictionState();
}

class _VoicePredictionState extends State<VoicePrediction> {
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
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios)),
      title: const Text("Voice Analysis"),
      actions: [],
      headerWidget: AnimatedSwitcher(
        switchInCurve: Curves.slowMiddle,
        switchOutCurve: Curves.ease,
        reverseDuration: Duration(milliseconds: 200),
        duration: Duration(milliseconds: 1200),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: loading
            ? CircularProgressIndicator.adaptive()
            : headerWidget(context),
      ),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        SizedBox(
          height: 20,
        ),
        AnimatedSwitcher(
          switchInCurve: Curves.elasticOut,
          switchOutCurve: Curves.ease,
          reverseDuration: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 1200),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: loading
              ? Center(child: CircularProgressIndicator.adaptive())
              : SingleChildScrollView(child: VoiceInputs()),
        ),
      ],
      fullyStretchable: false,
      expandedBody: Container(),
      backgroundColor: Colors.white,
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Image.asset(
      "assets/Voice chat-bro.png",
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
