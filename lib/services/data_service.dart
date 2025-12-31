import '../models/subject.dart';

class DataService {
  // Mock data service - Replace with actual API calls later
  static List<Subject> getSubjects() {
    return [
      Subject(
        id: 'physics',
        name: 'Physics',
        icon: 'science',
        description: 'Class 12 Physics - CBSE Syllabus',
        chapters: [
          Chapter(
            id: 'ch1',
            name: 'Electric Charges and Fields',
            subjectId: 'physics',
            description: 'Introduction to electric charges and fields',
            materials: [
              Material(
                id: 'm1',
                title: 'Chapter Notes',
                type: 'notes',
                url: '',
                chapterId: 'ch1',
                description: 'Complete chapter notes',
              ),
              Material(
                id: 'm2',
                title: 'Important Formulas',
                type: 'pdf',
                url: '',
                chapterId: 'ch1',
                description: 'All important formulas',
              ),
            ],
          ),
        ],
      ),
      Subject(
        id: 'chemistry',
        name: 'Chemistry',
        icon: 'biotech',
        description: 'Class 12 Chemistry - CBSE Syllabus',
        chapters: [],
      ),
      Subject(
        id: 'mathematics',
        name: 'Mathematics',
        icon: 'calculate',
        description: 'Class 12 Mathematics - CBSE Syllabus',
        chapters: [],
      ),
      Subject(
        id: 'biology',
        name: 'Biology',
        icon: 'eco',
        description: 'Class 12 Biology - CBSE Syllabus',
        chapters: [],
      ),
      Subject(
        id: 'english',
        name: 'English',
        icon: 'menu_book',
        description: 'Class 12 English - CBSE Syllabus',
        chapters: [],
      ),
    ];
  }

  static Subject? getSubjectById(String id) {
    return getSubjects().firstWhere(
      (subject) => subject.id == id,
      orElse: () => getSubjects().first,
    );
  }

  static Chapter? getChapterById(String subjectId, String chapterId) {
    final subject = getSubjectById(subjectId);
    if (subject == null) return null;
    
    try {
      return subject.chapters.firstWhere(
        (chapter) => chapter.id == chapterId,
      );
    } catch (e) {
      return null;
    }
  }
}

