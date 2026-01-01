import '../models/subject.dart';

class DataService {
  // Mock data service - Replace with actual API calls later
  static List<Subject> getSubjects() {
    return [
      // Physics
      Subject(
        id: 'physics',
        name: 'Physics',
        icon: 'science',
        description: 'Class 12 Physics - CBSE Syllabus',
        chapters: [
          Chapter(
            id: 'phy_ch1',
            name: 'Electric Charges and Fields',
            subjectId: 'physics',
            description: 'Electric charge, conductors and insulators, Coulomb\'s law, electric field, electric dipole',
            materials: [
              StudyMaterial(id: 'phy_ch1_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch1', description: 'Complete chapter notes with key concepts'),
              StudyMaterial(id: 'phy_ch1_m2', title: 'Important Formulas', type: 'pdf', url: '', chapterId: 'phy_ch1', description: 'All important formulas and derivations'),
              StudyMaterial(id: 'phy_ch1_m3', title: 'NCERT Solutions', type: 'pdf', url: '', chapterId: 'phy_ch1', description: 'Detailed NCERT solutions'),
              StudyMaterial(id: 'phy_ch1_m4', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch1', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch2',
            name: 'Electrostatic Potential and Capacitance',
            subjectId: 'physics',
            description: 'Electric potential, potential difference, equipotential surfaces, capacitors',
            materials: [
              StudyMaterial(id: 'phy_ch2_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch2', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch2_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'phy_ch2', description: 'Quick reference formulas'),
              StudyMaterial(id: 'phy_ch2_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch2', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch3',
            name: 'Current Electricity',
            subjectId: 'physics',
            description: 'Electric current, Ohm\'s law, resistance, Kirchhoff\'s laws, Wheatstone bridge',
            materials: [
              StudyMaterial(id: 'phy_ch3_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch3', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch3_m2', title: 'Circuit Diagrams', type: 'pdf', url: '', chapterId: 'phy_ch3', description: 'Important circuit diagrams'),
              StudyMaterial(id: 'phy_ch3_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch3', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch4',
            name: 'Moving Charges and Magnetism',
            subjectId: 'physics',
            description: 'Magnetic field, force on current-carrying conductor, Biot-Savart law, Ampere\'s law',
            materials: [
              StudyMaterial(id: 'phy_ch4_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch4', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch4_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'phy_ch4', description: 'All formulas'),
              StudyMaterial(id: 'phy_ch4_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch4', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch5',
            name: 'Magnetism and Matter',
            subjectId: 'physics',
            description: 'Bar magnet, magnetic field lines, magnetic dipole, Earth\'s magnetism',
            materials: [
              StudyMaterial(id: 'phy_ch5_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch5', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch5_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch5', description: '60 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch6',
            name: 'Electromagnetic Induction',
            subjectId: 'physics',
            description: 'Faraday\'s law, Lenz\'s law, self and mutual inductance, AC generator',
            materials: [
              StudyMaterial(id: 'phy_ch6_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch6', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch6_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'phy_ch6', description: 'Important formulas'),
              StudyMaterial(id: 'phy_ch6_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch6', description: '68 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch7',
            name: 'Alternating Current',
            subjectId: 'physics',
            description: 'AC voltage, phasors, LCR circuit, power in AC circuit, transformer',
            materials: [
              StudyMaterial(id: 'phy_ch7_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch7', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch7_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch7', description: '72 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch8',
            name: 'Electromagnetic Waves',
            subjectId: 'physics',
            description: 'Displacement current, electromagnetic spectrum, properties of EM waves',
            materials: [
              StudyMaterial(id: 'phy_ch8_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch8', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch8_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch8', description: '55 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch9',
            name: 'Ray Optics and Optical Instruments',
            subjectId: 'physics',
            description: 'Reflection, refraction, mirrors, lenses, optical instruments',
            materials: [
              StudyMaterial(id: 'phy_ch9_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch9', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch9_m2', title: 'Ray Diagrams', type: 'pdf', url: '', chapterId: 'phy_ch9', description: 'Important ray diagrams'),
              StudyMaterial(id: 'phy_ch9_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch9', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch10',
            name: 'Wave Optics',
            subjectId: 'physics',
            description: 'Huygens principle, interference, diffraction, polarization',
            materials: [
              StudyMaterial(id: 'phy_ch10_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch10', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch10_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch10', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch11',
            name: 'Dual Nature of Radiation and Matter',
            subjectId: 'physics',
            description: 'Photoelectric effect, de Broglie wavelength, Davisson-Germer experiment',
            materials: [
              StudyMaterial(id: 'phy_ch11_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch11', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch11_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch11', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch12',
            name: 'Atoms',
            subjectId: 'physics',
            description: 'Alpha-particle scattering, Bohr model, line spectra, de Broglie\'s explanation',
            materials: [
              StudyMaterial(id: 'phy_ch12_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch12', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch12_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch12', description: '60 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch13',
            name: 'Nuclei',
            subjectId: 'physics',
            description: 'Atomic masses, composition of nucleus, nuclear force, radioactivity',
            materials: [
              StudyMaterial(id: 'phy_ch13_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch13', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch13_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch13', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'phy_ch14',
            name: 'Semiconductor Electronics',
            subjectId: 'physics',
            description: 'Semiconductors, p-n junction, diodes, transistors, logic gates',
            materials: [
              StudyMaterial(id: 'phy_ch14_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'phy_ch14', description: 'Complete chapter notes'),
              StudyMaterial(id: 'phy_ch14_m2', title: 'Circuit Diagrams', type: 'pdf', url: '', chapterId: 'phy_ch14', description: 'Important circuits'),
              StudyMaterial(id: 'phy_ch14_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'phy_ch14', description: '75 MCQs with solutions'),
            ],
          ),
        ],
      ),
      // Chemistry
      Subject(
        id: 'chemistry',
        name: 'Chemistry',
        icon: 'biotech',
        description: 'Class 12 Chemistry - CBSE Syllabus',
        chapters: [
          Chapter(
            id: 'chem_ch1',
            name: 'The Solid State',
            subjectId: 'chemistry',
            description: 'Classification of solids, crystal lattices, unit cells, packing efficiency',
            materials: [
              StudyMaterial(id: 'chem_ch1_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch1', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch1_m2', title: 'Crystal Structures', type: 'pdf', url: '', chapterId: 'chem_ch1', description: 'Important crystal structures'),
              StudyMaterial(id: 'chem_ch1_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch1', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch2',
            name: 'Solutions',
            subjectId: 'chemistry',
            description: 'Types of solutions, concentration, colligative properties, Raoult\'s law',
            materials: [
              StudyMaterial(id: 'chem_ch2_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch2', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch2_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'chem_ch2', description: 'All formulas'),
              StudyMaterial(id: 'chem_ch2_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch2', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch3',
            name: 'Electrochemistry',
            subjectId: 'chemistry',
            description: 'Electrochemical cells, Nernst equation, conductance, batteries, fuel cells',
            materials: [
              StudyMaterial(id: 'chem_ch3_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch3', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch3_m2', title: 'Cell Diagrams', type: 'pdf', url: '', chapterId: 'chem_ch3', description: 'Electrochemical cell diagrams'),
              StudyMaterial(id: 'chem_ch3_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch3', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch4',
            name: 'Chemical Kinetics',
            subjectId: 'chemistry',
            description: 'Rate of reaction, order and molecularity, Arrhenius equation, catalysis',
            materials: [
              StudyMaterial(id: 'chem_ch4_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch4', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch4_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch4', description: '72 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch5',
            name: 'Surface Chemistry',
            subjectId: 'chemistry',
            description: 'Adsorption, colloids, emulsions, catalysis',
            materials: [
              StudyMaterial(id: 'chem_ch5_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch5', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch5_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch5', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch6',
            name: 'General Principles and Processes of Isolation of Elements',
            subjectId: 'chemistry',
            description: 'Occurrence of metals, concentration of ores, extraction, refining',
            materials: [
              StudyMaterial(id: 'chem_ch6_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch6', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch6_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch6', description: '60 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch7',
            name: 'The p-Block Elements',
            subjectId: 'chemistry',
            description: 'Group 15, 16, 17, 18 elements, their compounds and properties',
            materials: [
              StudyMaterial(id: 'chem_ch7_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch7', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch7_m2', title: 'Reaction Summary', type: 'pdf', url: '', chapterId: 'chem_ch7', description: 'Important reactions'),
              StudyMaterial(id: 'chem_ch7_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch7', description: '85 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch8',
            name: 'The d and f Block Elements',
            subjectId: 'chemistry',
            description: 'Transition elements, lanthanides, actinides, properties and uses',
            materials: [
              StudyMaterial(id: 'chem_ch8_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch8', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch8_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch8', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch9',
            name: 'Coordination Compounds',
            subjectId: 'chemistry',
            description: 'Werner\'s theory, ligands, coordination number, isomerism, bonding',
            materials: [
              StudyMaterial(id: 'chem_ch9_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch9', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch9_m2', title: 'Isomerism Types', type: 'pdf', url: '', chapterId: 'chem_ch9', description: 'Types of isomerism'),
              StudyMaterial(id: 'chem_ch9_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch9', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch10',
            name: 'Haloalkanes and Haloarenes',
            subjectId: 'chemistry',
            description: 'Nomenclature, nature of C-X bond, preparation, reactions, polyhalogen compounds',
            materials: [
              StudyMaterial(id: 'chem_ch10_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch10', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch10_m2', title: 'Reaction Mechanisms', type: 'pdf', url: '', chapterId: 'chem_ch10', description: 'SN1, SN2, E1, E2 mechanisms'),
              StudyMaterial(id: 'chem_ch10_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch10', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch11',
            name: 'Alcohols, Phenols and Ethers',
            subjectId: 'chemistry',
            description: 'Classification, nomenclature, preparation, physical and chemical properties',
            materials: [
              StudyMaterial(id: 'chem_ch11_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch11', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch11_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch11', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch12',
            name: 'Aldehydes, Ketones and Carboxylic Acids',
            subjectId: 'chemistry',
            description: 'Nomenclature, preparation, reactions, physical and chemical properties',
            materials: [
              StudyMaterial(id: 'chem_ch12_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch12', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch12_m2', title: 'Reaction Summary', type: 'pdf', url: '', chapterId: 'chem_ch12', description: 'Important reactions'),
              StudyMaterial(id: 'chem_ch12_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch12', description: '85 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch13',
            name: 'Amines',
            subjectId: 'chemistry',
            description: 'Classification, nomenclature, preparation, physical and chemical properties, diazonium salts',
            materials: [
              StudyMaterial(id: 'chem_ch13_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch13', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch13_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch13', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch14',
            name: 'Biomolecules',
            subjectId: 'chemistry',
            description: 'Carbohydrates, proteins, nucleic acids, vitamins, hormones',
            materials: [
              StudyMaterial(id: 'chem_ch14_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch14', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch14_m2', title: 'Structure Diagrams', type: 'pdf', url: '', chapterId: 'chem_ch14', description: 'Biomolecule structures'),
              StudyMaterial(id: 'chem_ch14_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch14', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch15',
            name: 'Polymers',
            subjectId: 'chemistry',
            description: 'Classification, types of polymerization, biodegradable polymers, commercial polymers',
            materials: [
              StudyMaterial(id: 'chem_ch15_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch15', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch15_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch15', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'chem_ch16',
            name: 'Chemistry in Everyday Life',
            subjectId: 'chemistry',
            description: 'Drugs, medicines, therapeutic action, chemicals in food, cleansing agents',
            materials: [
              StudyMaterial(id: 'chem_ch16_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'chem_ch16', description: 'Complete chapter notes'),
              StudyMaterial(id: 'chem_ch16_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'chem_ch16', description: '60 MCQs with solutions'),
            ],
          ),
        ],
      ),
      // Mathematics
      Subject(
        id: 'mathematics',
        name: 'Mathematics',
        icon: 'calculate',
        description: 'Class 12 Mathematics - CBSE Syllabus',
        chapters: [
          Chapter(
            id: 'math_ch1',
            name: 'Relations and Functions',
            subjectId: 'mathematics',
            description: 'Types of relations, functions, composition of functions, invertible functions',
            materials: [
              StudyMaterial(id: 'math_ch1_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch1', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch1_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'math_ch1', description: 'Important formulas'),
              StudyMaterial(id: 'math_ch1_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch1', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch2',
            name: 'Inverse Trigonometric Functions',
            subjectId: 'mathematics',
            description: 'Inverse trigonometric functions, their domains and ranges, properties',
            materials: [
              StudyMaterial(id: 'math_ch2_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch2', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch2_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch2', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch3',
            name: 'Matrices',
            subjectId: 'mathematics',
            description: 'Types of matrices, operations on matrices, transpose, symmetric and skew-symmetric matrices',
            materials: [
              StudyMaterial(id: 'math_ch3_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch3', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch3_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch3', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch4',
            name: 'Determinants',
            subjectId: 'mathematics',
            description: 'Determinant of a matrix, properties, area of triangle, minors and cofactors',
            materials: [
              StudyMaterial(id: 'math_ch4_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch4', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch4_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch4', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch5',
            name: 'Continuity and Differentiability',
            subjectId: 'mathematics',
            description: 'Continuity, differentiability, chain rule, derivatives of implicit functions',
            materials: [
              StudyMaterial(id: 'math_ch5_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch5', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch5_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'math_ch5', description: 'Derivative formulas'),
              StudyMaterial(id: 'math_ch5_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch5', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch6',
            name: 'Application of Derivatives',
            subjectId: 'mathematics',
            description: 'Rate of change, increasing and decreasing functions, tangents and normals, maxima and minima',
            materials: [
              StudyMaterial(id: 'math_ch6_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch6', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch6_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch6', description: '85 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch7',
            name: 'Integrals',
            subjectId: 'mathematics',
            description: 'Integration as inverse of differentiation, methods of integration, definite integrals',
            materials: [
              StudyMaterial(id: 'math_ch7_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch7', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch7_m2', title: 'Integration Formulas', type: 'pdf', url: '', chapterId: 'math_ch7', description: 'All integration formulas'),
              StudyMaterial(id: 'math_ch7_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch7', description: '90 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch8',
            name: 'Application of Integrals',
            subjectId: 'mathematics',
            description: 'Area under simple curves, area between two curves',
            materials: [
              StudyMaterial(id: 'math_ch8_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch8', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch8_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch8', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch9',
            name: 'Differential Equations',
            subjectId: 'mathematics',
            description: 'Order and degree, general and particular solutions, methods of solving differential equations',
            materials: [
              StudyMaterial(id: 'math_ch9_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch9', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch9_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch9', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch10',
            name: 'Vector Algebra',
            subjectId: 'mathematics',
            description: 'Vectors, scalar and vector products, scalar triple product',
            materials: [
              StudyMaterial(id: 'math_ch10_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch10', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch10_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch10', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch11',
            name: 'Three Dimensional Geometry',
            subjectId: 'mathematics',
            description: 'Direction cosines and ratios, equation of line, equation of plane, angle between lines and planes',
            materials: [
              StudyMaterial(id: 'math_ch11_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch11', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch11_m2', title: 'Formula Sheet', type: 'pdf', url: '', chapterId: 'math_ch11', description: '3D geometry formulas'),
              StudyMaterial(id: 'math_ch11_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch11', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch12',
            name: 'Linear Programming',
            subjectId: 'mathematics',
            description: 'Linear programming problems, graphical method, optimal solution',
            materials: [
              StudyMaterial(id: 'math_ch12_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch12', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch12_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch12', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'math_ch13',
            name: 'Probability',
            subjectId: 'mathematics',
            description: 'Conditional probability, multiplication theorem, independent events, Bayes\' theorem, random variables',
            materials: [
              StudyMaterial(id: 'math_ch13_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'math_ch13', description: 'Complete chapter notes'),
              StudyMaterial(id: 'math_ch13_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'math_ch13', description: '75 MCQs with solutions'),
            ],
          ),
        ],
      ),
      // Biology
      Subject(
        id: 'biology',
        name: 'Biology',
        icon: 'eco',
        description: 'Class 12 Biology - CBSE Syllabus',
        chapters: [
          Chapter(
            id: 'bio_ch1',
            name: 'Reproduction in Organisms',
            subjectId: 'biology',
            description: 'Asexual and sexual reproduction, life span, events in sexual reproduction',
            materials: [
              StudyMaterial(id: 'bio_ch1_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch1', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch1_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch1', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch2',
            name: 'Sexual Reproduction in Flowering Plants',
            subjectId: 'biology',
            description: 'Flower structure, pollination, fertilization, seed and fruit development',
            materials: [
              StudyMaterial(id: 'bio_ch2_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch2', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch2_m2', title: 'Diagrams', type: 'pdf', url: '', chapterId: 'bio_ch2', description: 'Important diagrams'),
              StudyMaterial(id: 'bio_ch2_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch2', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch3',
            name: 'Human Reproduction',
            subjectId: 'biology',
            description: 'Male and female reproductive systems, gametogenesis, menstrual cycle, fertilization, pregnancy',
            materials: [
              StudyMaterial(id: 'bio_ch3_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch3', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch3_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch3', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch4',
            name: 'Reproductive Health',
            subjectId: 'biology',
            description: 'Problems and strategies, population control, medical termination of pregnancy, infertility',
            materials: [
              StudyMaterial(id: 'bio_ch4_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch4', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch4_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch4', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch5',
            name: 'Principles of Inheritance and Variation',
            subjectId: 'biology',
            description: 'Mendel\'s laws, inheritance patterns, chromosomal theory, linkage, genetic disorders',
            materials: [
              StudyMaterial(id: 'bio_ch5_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch5', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch5_m2', title: 'Genetic Crosses', type: 'pdf', url: '', chapterId: 'bio_ch5', description: 'Important genetic crosses'),
              StudyMaterial(id: 'bio_ch5_m3', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch5', description: '85 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch6',
            name: 'Molecular Basis of Inheritance',
            subjectId: 'biology',
            description: 'DNA structure, replication, transcription, translation, genetic code, regulation',
            materials: [
              StudyMaterial(id: 'bio_ch6_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch6', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch6_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch6', description: '90 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch7',
            name: 'Evolution',
            subjectId: 'biology',
            description: 'Origin of life, evolution of life forms, evidence, adaptive radiation, human evolution',
            materials: [
              StudyMaterial(id: 'bio_ch7_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch7', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch7_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch7', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch8',
            name: 'Human Health and Disease',
            subjectId: 'biology',
            description: 'Common diseases, immunity, AIDS, cancer, drugs and alcohol abuse',
            materials: [
              StudyMaterial(id: 'bio_ch8_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch8', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch8_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch8', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch9',
            name: 'Strategies for Enhancement in Food Production',
            subjectId: 'biology',
            description: 'Animal husbandry, plant breeding, single cell protein, tissue culture',
            materials: [
              StudyMaterial(id: 'bio_ch9_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch9', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch9_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch9', description: '65 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch10',
            name: 'Microbes in Human Welfare',
            subjectId: 'biology',
            description: 'Microbes in food processing, sewage treatment, energy production, biofertilizers',
            materials: [
              StudyMaterial(id: 'bio_ch10_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch10', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch10_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch10', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch11',
            name: 'Biotechnology: Principles and Processes',
            subjectId: 'biology',
            description: 'Principles, tools, processes, cloning vectors, competent host, bioprocess engineering',
            materials: [
              StudyMaterial(id: 'bio_ch11_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch11', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch11_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch11', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch12',
            name: 'Biotechnology and its Applications',
            subjectId: 'biology',
            description: 'Applications in agriculture, medicine, transgenic animals, ethical issues',
            materials: [
              StudyMaterial(id: 'bio_ch12_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch12', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch12_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch12', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch13',
            name: 'Organisms and Populations',
            subjectId: 'biology',
            description: 'Organism and its environment, populations, population interactions',
            materials: [
              StudyMaterial(id: 'bio_ch13_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch13', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch13_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch13', description: '75 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch14',
            name: 'Ecosystem',
            subjectId: 'biology',
            description: 'Ecosystem structure, productivity, decomposition, energy flow, ecological pyramids',
            materials: [
              StudyMaterial(id: 'bio_ch14_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch14', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch14_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch14', description: '80 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch15',
            name: 'Biodiversity and Conservation',
            subjectId: 'biology',
            description: 'Biodiversity, patterns, importance, loss, conservation',
            materials: [
              StudyMaterial(id: 'bio_ch15_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch15', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch15_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch15', description: '70 MCQs with solutions'),
            ],
          ),
          Chapter(
            id: 'bio_ch16',
            name: 'Environmental Issues',
            subjectId: 'biology',
            description: 'Air pollution, water pollution, solid waste, radioactive waste, greenhouse effect, ozone depletion',
            materials: [
              StudyMaterial(id: 'bio_ch16_m1', title: 'Chapter Notes', type: 'notes', url: '', chapterId: 'bio_ch16', description: 'Complete chapter notes'),
              StudyMaterial(id: 'bio_ch16_m2', title: 'MCQ Practice', type: 'quiz', url: '', chapterId: 'bio_ch16', description: '75 MCQs with solutions'),
            ],
          ),
        ],
      ),
    ];
  }

  static Subject? getSubjectById(String id) {
    try {
      return getSubjects().firstWhere(
        (subject) => subject.id == id,
      );
    } catch (e) {
      return null;
    }
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
