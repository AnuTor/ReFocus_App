import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/survey_screen.dart';
import '../providers/survey.dart';

class SurveyElement extends StatefulWidget {
  final String path;
  final Survey survey;
  final int num;
  final bool enable;

  const SurveyElement({
    Key? key,
    required this.path,
    required this.survey,
    required this.num,
    this.enable = true,
  }) : super(key: key);

  @override
  State<SurveyElement> createState() => _SurveyElementState();
}

class _SurveyElementState extends State<SurveyElement> {
  @override
  void initState() {
    super.initState();
    refreshDone();
  }

  Future<void> refreshDone() async {
    if (widget.enable && !widget.survey.done) {
      //solo ejecuta checkDone() si no está hecha la encuesta y está habilitada
      bool isAlreadyDone = await checkDone();
      if (isAlreadyDone) {
        setState(() {
          widget.survey.setDone();
        });
      }
    }
  }

  Future<bool> checkDone() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('questionnaires')
        .where('userId', isEqualTo: user.uid)
        .where('path', isEqualTo: widget.path)
        .where('questionnaire', isEqualTo: widget.survey.testName)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.survey.done,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enable
            ? () => {
                  Navigator.of(context).pushNamed(
                    SurveyScreen.routeName,
                    arguments: {'path': widget.path, 'survey': widget.survey},
                  ).whenComplete(() => setState(() {
                        refreshDone();
                      })),
                }
            : null,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                onPressed: widget.enable
                    ? () => {
                          Navigator.of(context).pushNamed(
                            SurveyScreen.routeName,
                            arguments: {
                              'path': widget.path,
                              'survey': widget.survey
                            },
                          ).whenComplete(() => setState(() {
                                refreshDone();
                              })),
                        }
                    : null,
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 22),
                    shape: widget.enable
                        ? const CircleBorder(
                            side:
                                BorderSide(width: 3, color: Color(0xFFF9A826)))
                        : const CircleBorder(),
                    //shape: const CircleBorder(),
                    backgroundColor: (widget.enable && !widget.survey.done)
                        ? Colors.grey.shade200
                        : const Color(0xFFF9A826),
                    padding: const EdgeInsets.all(15)),
                child: widget.enable
                    ? (widget.survey.done
                        ? const Icon(Icons.check)
                        : Text(widget.num.toString()))
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
                  const Text(
                    'Cuestionario',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  Text(
                    '${widget.survey.questions.length} preguntas',
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
