# Revision Adda - Class 12 (CBSE)

यह repository Class 12 (CBSE) बोर्ड परीक्षा की तैयारी के लिए बनाया गया है। इसका उद्देश्य छात्रों को chapter-wise concise notes, sample/previous year papers, प्रश्न बैंक, formula sheets और प्रैक्टिस क्विज़ के रूप में व्यवस्थित सामग्री उपलब्ध कराना है — ताकि टेस्ट की तैयारी तेज़ और प्रभावी हो।

## Projects / फ़ोल्डर और उनकी जानकारी

- flutter_app/  
  - Description: Revision Adda का Flutter (Dart) ऐप — notes viewer, chapter-wise पढ़ाई, quizzes, timed mock tests, progress tracker।  
  - इस्तेमाल: Android/iOS पर install/run करने के लिए Flutter SDK चाहिए。
- notes/Physics/  
  - Description: chapter-wise concise notes, solved numerical examples, formula sheet, important diagrams.  
  - फाइलें: `01_Mechanics.md`, `02_Electricity.md`, `formula_sheet.pdf`, `solved_examples/`  
- notes/Chemistry/  
  - Description: Physical, Organic, Inorganic के short notes, reactions summary, mechanism quick reference, solved problems。
- notes/Mathematics/  
  - Description: chapter-wise theorems, solved examples, past paper problems, step-by-step solutions。
- notes/Biology/  
  - Description: diagrams, definitions, processes, important experiments और expected short/long answer points।
- notes/Accountancy/  
  - Description: accounting entries, ledgers, financial statements, chapter practice problems。
- notes/BusinessStudies/  
  - Description: theory points, case study approach, definitions, sample answers。
- notes/Economics/  
  - Description: micro & macro notes, numerical problems, graphs और model answers。
- notes/ComputerScience/  
  - Description: CBSE Class 12 Computer Science theory और programs (Python/Java/Dart) — practicals और sample code。
- sample_papers/  
  - Description: chapter-wise और full-length sample papers, solved and unsolved sets, time-bound mock papers。
- previous_year_papers/  
  - Description: पिछले वर्षों के CBSE बोर्ड प्रश्नपत्र (solved & unsolved)।
- question_bank/  
  - Description: ऑब्जेक्टिव (MCQ), short-answer, long-answer प्रश्न — chapter और difficulty टैग के साथ।
- formula_sheets/  
  - Description: सभी विषयों की quick-reference formula sheets (PDF/MD)。
- practicals/  
  - Description: Physics/Chemistry/Biology practical notebooks, viva questions, observation tables。
- common/  
  - Files: `study-planner.pdf`, `timetable-template.xlsx`, `exam-tips.md`, `cheat-sheets/`  
  - Description: general resources, exam day tips, time management, revision checklist。
- assets/  
  - Description: images, mindmaps, diagrams, infographics used across notes and app。
- docs/  
  - Description: contributing guidelines, content standards, license details, content sourcing rules。

> नोट: फ़ोल्डर/फाइल names chapter-numbered रखें ताकि order बना रहे (उदा. `01_Intro.md`, `02_SomeChapter.md`)।

## How to use / कैसे उपयोग करें

1. रिपॉज़िटरी क्लोन करें:
   ```bash
   git clone https://github.com/ShubhamkrTiwari/revisionadda12.git
   ```
2. अपने विषय/फ़ोल्डर में जाएँ और संबंधित Markdown/PDF खोलें।  
3. Flutter ऐप रन करने के लिए `flutter pub get` और `flutter run` (यदि आपका सिस्टम Flutter सेटअप है)。  
4. practice के लिए `sample_papers/` और `question_bank/` का उपयोग करें — time-bound mock tests के लिए ऐप का उपयोग करें。

## Contributing / योगदान कैसे करें

- नई सामग्री जोड़ने के लिए:
  - नए नोट/पेज जोड़ें: नाम स्पष्ट और chapter-numbered रखें (उदा. `03_Thermodynamics.md`)।
  - स्रोत/हवाला दें यदि सामग्री कहीं से ली गयी है।
  - images/assets डालते समय `assets/` में रखें और path README/notes में अपडेट करें।
- ऐप/कोड प्रोजेक्ट में योगदान के लिए:
  - नया branch बनाकर PR भेजें (feature/bugfix के नाम रखें)。
  - code style और linting rules का पालन करें (Flutter/Dart analyzer)。
- Issue खोलने से पहले existing issues चेक करें; अगर कोई नया suggestion हो तो Issue बनाएं और उसके बाद PR भेजें。

## Content Standards / सामग्री के नियम
- हर academic सामग्री factual और syllabus-aligned होनी चाहिए (CBSE Class 12 latest syllabus के according)。  
- महत्वपूर्ण सूत्र/परिभाषाएँ हाइलाइट करें。  
- copyrighted third-party content जोड़ते समय proper attribution दें और commercial-use से बचें。

## License / लाइसेंस
यह repository educational purposes के लिए है। कोई भी सामग्री non-commercial educational उपयोग के लिए उपलब्ध है। अगर आप explicit लाइसेंस जोड़ना चाहें (MIT, CC-BY, आदि) तो PR कर दें。

## Contact / संपर्क
किसी सुझाव, गलती सुधार या नई सामग्री के लिए Issues खोलें या GitHub पर message भेजें: https://github.com/ShubhamkrTiwari

---
यदि आप चाहें तो मैं README को और छोटा/लंबा कर दूँ या किसी specific फॉर्मैट (English/Hinglish/plain English) में भी दे सकता/सकती हूँ。