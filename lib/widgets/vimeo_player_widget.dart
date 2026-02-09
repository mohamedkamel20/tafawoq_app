// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import '../constants.dart';
import '../providers/my_courses.dart';
import '../providers/shared_pref_helper.dart';
import 'package:http/http.dart' as http;

class VimeoPlayerWidget extends StatefulWidget {
  static const routeName = '/vimeoPlayer';
  final int courseId;
  final int? lessonId;
  final String vimeoVideoId;

  const VimeoPlayerWidget({
    super.key,
    required this.courseId,
    this.lessonId,
    required this.vimeoVideoId,
  });

  @override
  State<VimeoPlayerWidget> createState() => _VimeoPlayerWidgetState();
}

class _VimeoPlayerWidgetState extends State<VimeoPlayerWidget> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.lessonId != null) {
      timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => updateWatchHistory(),
      );
    }
  }

  Future<void> updateWatchHistory() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    if (token != null && token.isNotEmpty) {
      var url = "$BASE_URL/api/update_watch_history/$token";
      try {
        final response = await http.post(
          Uri.parse(url),
          body: {
            'course_id': widget.courseId.toString(),
            'lesson_id': widget.lessonId.toString(),
            'current_duration': '0', // Updated by video player progress
          },
        );

        final responseData = json.decode(response.body);
        if (responseData != null) {
          var isCompleted = responseData['is_completed'];
          if (isCompleted == 1) {
            Provider.of<MyCourses>(context, listen: false)
                .updateDripContendLesson(
                    widget.courseId,
                    responseData['course_progress'],
                    responseData['number_of_completed_lessons']);
          }
        }
      } catch (error) {
        // Handle error silently
      }
    }
  }

  @override
  void dispose() {
    if (widget.lessonId != null && timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: VimeoVideoPlayer(
            videoId: widget.vimeoVideoId,
          ),
        ),
      ),
    );
  }
}
