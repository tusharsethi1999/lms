import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lms/models/assignment_definition.dart';
import 'package:lms/models/assignment_detail.dart';
import 'package:lms/models/course.dart';
import 'package:lms/models/user.dart';
import 'package:lms/pages/course_details.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final WidgetRef ref;
  final BuildContext context;
  final int index;
  final User user;

  const CourseCard({
    super.key,
    required this.context,
    required this.course,
    required this.ref,
    required this.index,
    required this.user,
  });

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.greenAccent.shade400;
      case 'B':
        return Colors.yellowAccent.shade700;
      case 'C':
        return Colors.orangeAccent;
      case 'D':
        return Colors.redAccent;
      case 'F':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    const grades = ['A', 'B', 'C', 'D', 'F', 'A', 'F'];
    final course = this.course.copyWith(grade: grades[Random().nextInt(7)]);
    return Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(6, 6),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.grey,
                offset: Offset(-6, -6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailsPage(course: course),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Instructor: ${course.instructor?.name ?? 'TBA'}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Schedule: ${course.schedule}',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (user.role == 'Student')
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showGradeDialog(context, course),
                          borderRadius: BorderRadius.circular(60),
                          splashColor: _gradeColor(
                            course.grade,
                          ).withValues(alpha: .3),
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _gradeColor(
                                    course.grade,
                                  ).withValues(alpha: 0.9),
                                  _gradeColor(course.grade),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _gradeColor(
                                    course.grade,
                                  ).withValues(alpha: .6),
                                  offset: const Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              course.grade,
                              style: GoogleFonts.oswald(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black38,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ).animate().scale(
                              begin: const Offset(0.7, 0.7),
                              end: const Offset(1.0, 1.0),
                              duration: 400.ms,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeIn)
        .slideX(begin: -0.3, end: 0, duration: 500.ms);
  }

  void _showGradeDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Consumer(
              builder: (ctx, ref, _) {
                // Static assignment definitions
                final defs = [
                  AssignmentDefinition(
                    assignmentId: '1',
                    assignmentName: 'Homework 1',
                    totalMarks: 10,
                    weight: 0.3,
                  ),
                  AssignmentDefinition(
                    assignmentId: '2',
                    assignmentName: 'Midterm Exam',
                    totalMarks: 20,
                    weight: 0.5,
                  ),
                  AssignmentDefinition(
                    assignmentId: '3',
                    assignmentName: 'Final Project',
                    totalMarks: 30,
                    weight: 0.2,
                  ),
                ];

                // Static completed assignments
                final doneList = [
                  AssignmentDetail(
                    gradeId: course.gradeId ?? '',
                    assignmentName: 'Homework 1',
                    assignmentId: '1',
                    obtainedMarks: 8,
                    totalMarks: 10,
                  ),
                ];

                final sliderValues = <String, double>{};

                return StatefulBuilder(
                  builder: (context, setParentState) {
                    double totalGrade = 0;
                    for (final def in defs) {
                      final doneDetail =
                          (() {
                            try {
                              return doneList.firstWhere(
                                (d) => d.assignmentId == def.assignmentId,
                              );
                            } catch (e) {
                              return null;
                            }
                          })();
                      final obtained =
                          doneDetail != null
                              ? doneDetail.obtainedMarks
                              : sliderValues[def.assignmentId] ?? 0;
                      totalGrade += (obtained / def.totalMarks) * def.weight;
                    }
                    totalGrade *= 100;

                    return AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: Text(
                        'Assignment Breakdown',
                        style: GoogleFonts.oswald(color: Colors.white),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...defs.map<Widget>((def) {
                              final doneDetail = doneList.firstWhere(
                                (d) => d.assignmentId == def.assignmentId,
                                orElse:
                                    () => AssignmentDetail(
                                      gradeId: course.gradeId ?? '',
                                      assignmentName: 'Sample Assignment',
                                      assignmentId: 'assign_1',
                                      obtainedMarks: 95,
                                      totalMarks: 100,
                                    ),
                              );
                              final isDone = doneDetail != null;
                              final total =
                                  isDone
                                      ? doneDetail.totalMarks
                                      : def.totalMarks;
                              final initial =
                                  isDone ? doneDetail.obtainedMarks : 0.0;
                              sliderValues.putIfAbsent(
                                def.assignmentId,
                                () => initial,
                              );

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      def.assignmentName,
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        final val =
                                            sliderValues[def.assignmentId]!;
                                        return Column(
                                          children: [
                                            Slider(
                                              value: val,
                                              max: total,
                                              divisions: total.toInt(),
                                              label:
                                                  '${val.toInt()}/${total.toInt()}',
                                              onChanged:
                                                  isDone
                                                      ? null
                                                      : (v) {
                                                        setState(() {
                                                          sliderValues[def
                                                                  .assignmentId] =
                                                              v;
                                                        });
                                                        setParentState(
                                                          () {},
                                                        ); // Update parent state
                                                      },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${val.toInt()}/${total.toInt()}',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                if (!isDone)
                                                  Text(
                                                    '${(def.weight * 100).toStringAsFixed(0)}% weight',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Final Grade: ${totalGrade.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
    );
  }
}
