import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';

class CoursesNotifier extends StateNotifier<List<Course>> {
  CoursesNotifier()
      : super([
          Course(
            title: 'CS601 - Advanced Distributed Systems',
            instructor: 'Dr. Rajesh Verma',
            schedule: 'Mon & Wed · 10:00 AM - 11:30 AM',
            progress: 0.3,
          ),
          Course(
            title: 'CS604 - Machine Learning',
            instructor: 'Prof. Anjali Rao',
            schedule: 'Tue & Thu · 2:00 PM - 3:30 PM',
            progress: 0.6,
          ),
          Course(
            title: 'CS610 - Human-Computer Interaction',
            instructor: 'Dr. Meera Sharma',
            schedule: 'Fri · 9:00 AM - 12:00 PM',
            progress: 0.2,
          ),
          Course(
            title: 'CS621 - Cloud Computing',
            instructor: 'Dr. Vivek Patel',
            schedule: 'Mon & Wed · 1:00 PM - 2:30 PM',
            progress: 0.4,
          ),
        ]);

  void updateProgress(int index, double newProgress) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(progress: newProgress)
        else
          state[i]
    ];
  }
}

final coursesProvider =
    StateNotifierProvider<CoursesNotifier, List<Course>>((ref) {
  return CoursesNotifier();
});
