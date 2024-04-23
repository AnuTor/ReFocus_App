import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../providers/activity.dart';
import '../screens/activity_screen.dart';

class ActivityElement extends StatefulWidget {
  final String path;
  final Activity activity;
  final bool enable;

  const ActivityElement({
    Key? key,
    required this.path,
    required this.activity,
    this.enable = true,
  }) : super(key: key);

  @override
  State<ActivityElement> createState() => _ActivityElementState();
}

class _ActivityElementState extends State<ActivityElement> {
  @override
  void initState() {
    super.initState();
    refreshDone();
  }

  Future<void> refreshDone() async {
    if (widget.enable && !widget.activity.done) {
      bool isAlreadyDone = await checkDone();
      if (isAlreadyDone) {
        setState(() {
          widget.activity.setDone();
        });
      }
    }
  }

  Future<bool> checkDone() async {
    final user = FirebaseAuth.instance.currentUser!;
    final activityDone = await FirebaseFirestore.instance
        .collection('activitiesDone')
        .where('UserID', isEqualTo: user.uid)
        .where('path', isEqualTo: widget.path)
        .where('activity', isEqualTo: widget.activity.title)
        .limit(1)
        .get();
    return activityDone.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 22),
      shape: widget.enable
          ? CircleBorder(
              side: BorderSide(width: 3, color: Theme.of(context).primaryColor))
          : const CircleBorder(),
      //fixedSize: Size(60, 60),
      padding: const EdgeInsets.all(15),
      backgroundColor: widget.activity.done ? null : Colors.grey.shade200,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enable
          ? () => {
                Navigator.of(context).pushNamed(
                  ActivityScreen.routeName,
                  arguments: {'path': widget.path, 'activity': widget.activity},
                ).whenComplete(() => setState(() {
                      refreshDone();
                    })),
              }
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              onPressed: widget.enable
                  ? () => {
                        Navigator.of(context).pushNamed(
                          ActivityScreen.routeName,
                          arguments: {
                            'path': widget.path,
                            'activity': widget.activity
                          },
                        ).whenComplete(() => setState(() {
                              refreshDone();
                            })),
                      }
                  : null,
              style: style,
              child: widget.enable
                  ? Text((widget.activity.id - 1).toString())
                  : const Icon(Icons.lock),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.activity.title,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
                widget.activity.audio
                    ? const Text(
                        'Audio',
                        style: TextStyle(color: Colors.grey),
                      )
                    : const Text(
                        'Texto',
                        style: TextStyle(color: Colors.grey),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
