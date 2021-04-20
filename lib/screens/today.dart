import 'package:flutter/material.dart';
import 'package:kostka/events/event_manager.dart';
import 'package:kostka/view/event_row.dart';


class Today extends StatefulWidget {

  final EventManager manager;

  const Today(this.manager);

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {

  @override
  void initState() {
    super.initState();
  }


  ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
    );

    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                widget.manager.currentEdge==0 ? "":"Strona:${widget.manager.currentEdge}",
                style: TextStyle(fontSize: 32),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,70),
                  child: ListView(
                    shrinkWrap: true,
                    controller: scrollController,
                    children: widget.manager.getTodayEvents().map<Widget>((e) => EventRow(e)).toList(),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}