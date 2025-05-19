import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dashboard.dart';
import 'student_management.dart';
import 'user_management.dart';
import 'parent_guardian.dart';
import 'audit_logs.dart';

class AttendanceRecord {
  final String id;
  final String studentId;
  final DateTime date;
  final TimeOfDay dropOffTime;
  final TimeOfDay pickupTime;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.date,
    required this.dropOffTime,
    required this.pickupTime,
    required this.isPresent,
  });
}

class StudentAttendance {
  final String id;
  final String name;
  final String grade;
  final String section;
  final String imageUrl;
  final List<AttendanceRecord> records;
  final double attendancePercentage;
  final String lastScan;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.imageUrl,
    required this.records,
    required this.attendancePercentage,
    required this.lastScan,
  });
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Dummy data for students
  final List<StudentAttendance> _students = [
    StudentAttendance(
      id: 'S001',
      name: 'Alice Johnson',
      grade: 'Kindergarten',
      section: 'K-A',
      imageUrl: 'assets/profiles/student1.png',
      attendancePercentage: 95,
      lastScan: '8:15 AM',
      records: _generateMonthRecords('S001', 2025, 5, 0.95),
    ),
    StudentAttendance(
      id: 'S002',
      name: 'Bob Smith',
      grade: 'Kindergarten',
      section: 'K-A',
      imageUrl: 'assets/profiles/student2.png',
      attendancePercentage: 93,
      lastScan: '8:15 AM',
      records: _generateMonthRecords('S002', 2025, 5, 0.93),
    ),
    StudentAttendance(
      id: 'S003',
      name: 'Carol Williams',
      grade: 'Kindergarten',
      section: 'K-A',
      imageUrl: 'assets/profiles/student3.png',
      attendancePercentage: 95,
      lastScan: 'Absent',
      records: _generateMonthRecords('S003', 2025, 5, 0.90),
    ),
    StudentAttendance(
      id: 'S004',
      name: 'David Brown',
      grade: 'Preschool',
      section: 'P-B',
      imageUrl: 'assets/profiles/student4.png',
      attendancePercentage: 98,
      lastScan: '8:12 AM',
      records: _generateMonthRecords('S004', 2025, 5, 0.98),
    ),
    StudentAttendance(
      id: 'S005',
      name: 'Eva Martinez',
      grade: 'Grade 1',
      section: 'G1-C',
      imageUrl: 'assets/profiles/student5.png',
      attendancePercentage: 97,
      lastScan: '8:10 AM',
      records: _generateMonthRecords('S005', 2025, 5, 0.97),
    ),
  ];

  // Currently selected filters
  String _selectedGrade = 'Kindergarten';
  final String _selectedTimeFrame = 'This Week';

  // Selected student for detailed view
  StudentAttendance? _selectedStudent;

  // Currently displayed month for calendar view
  DateTime _currentMonth = DateTime(2025, 5, 1); // May 2025

  // Generate dummy attendance records for a specific month
  static List<AttendanceRecord> _generateMonthRecords(
      String studentId, int year, int month, double presentRatio) {
    final records = <AttendanceRecord>[];
    final random = DateTime.now().millisecondsSinceEpoch;

    // Get the first and last day of the month
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    // Include some days from previous month
    final previousMonthDays =
        firstDay.weekday % 7; // Days to show from previous month
    for (int i = previousMonthDays; i > 0; i--) {
      final date = firstDay.subtract(Duration(days: i));
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        records.add(AttendanceRecord(
          id: '${studentId}_${date.year}${date.month}${date.day}',
          studentId: studentId,
          date: date,
          dropOffTime: const TimeOfDay(hour: 8, minute: 30),
          pickupTime: const TimeOfDay(hour: 15, minute: 30),
          isPresent: (random % date.day % 5) != 0, // Pattern for present/absent
        ));
      }
    }

    // Current month
    for (var day = 1; day <= lastDay.day; day++) {
      final date = DateTime(year, month, day);
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        final isPresent = (random % day % 10) != 3; // Generate a pattern
        records.add(AttendanceRecord(
          id: '${studentId}_$year$month$day',
          studentId: studentId,
          date: date,
          dropOffTime: const TimeOfDay(hour: 8, minute: 30),
          pickupTime: const TimeOfDay(hour: 15, minute: 30),
          isPresent: isPresent,
        ));
      }
    }

    // Next month (to complete the view)
    final daysFromNextMonth = 42 - (previousMonthDays + lastDay.day);
    for (int i = 1; i <= daysFromNextMonth; i++) {
      final date = DateTime(year, month + 1, i);
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        records.add(AttendanceRecord(
          id: '${studentId}_${date.year}${date.month}${date.day}',
          studentId: studentId,
          date: date,
          dropOffTime: const TimeOfDay(hour: 8, minute: 30),
          pickupTime: const TimeOfDay(hour: 15, minute: 30),
          isPresent: (random % i % 7) != 0,
        ));
      }
    }

    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'KidSync',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.people,
                  title: 'Student Management',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const StudentManagementScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.person,
                  title: 'User Management',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserManagementScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.family_restroom,
                  title: 'Parent/Guardian',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ParentGuardianScreen()),
                    );
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.calendar_today,
                  title: 'Attendance',
                  isSelected: true,
                ),
                _buildSidebarItem(
                  icon: Icons.description,
                  title: 'Audit Logs',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuditLogsScreen()),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, size: 20),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              child: _selectedStudent == null
                  ? _buildStudentListView()
                  : _buildCalendarView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStudentListView() {
    // Filter students based on selected grade
    final filteredStudents = _students.where((student) {
      return _selectedGrade == 'All' || student.grade == _selectedGrade;
    }).toList();

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Admin',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.brown.shade300,
                child: const Text('A'),
              ),
            ],
          ),
        ),

        // Filter buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildGradeFilterButton('Kindergarten'),
              const SizedBox(width: 8),
              _buildGradeFilterButton('Preschool'),
              const SizedBox(width: 8),
              _buildGradeFilterButton('Grade 1-6', hasDropdown: true),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 5),
                    Text(_selectedTimeFrame),
                    const SizedBox(width: 5),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 200,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search student',
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Students list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Student',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main student list
              Expanded(
                flex: 4,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: AssetImage(student.imageUrl),
                          onBackgroundImageError: (_, __) {},
                          child: const Text(''),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('${student.grade} • ${student.section}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Present/Absent indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: student.lastScan != 'Absent'
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                student.lastScan != 'Absent'
                                    ? 'Present'
                                    : 'Absent',
                                style: TextStyle(
                                  color: student.lastScan != 'Absent'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Attendance info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Last Scan: ${student.lastScan}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Attendance: ${student.attendancePercentage.toInt()}%',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // View Details button
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedStudent = student;
                                });
                              },
                              child: const Text('View Details',
                                  style: TextStyle(color: Colors.green)),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.green),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Grade list on the side
              if (_selectedGrade == 'Grade 1-6')
                Container(
                  width: 100,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildGradeSidebarItem('Grade 1'),
                      _buildGradeSidebarItem('Grade 2'),
                      _buildGradeSidebarItem('Grade 3'),
                      _buildGradeSidebarItem('Grade 4'),
                      _buildGradeSidebarItem('Grade 5'),
                      _buildGradeSidebarItem('Grade 6'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradeSidebarItem(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: Colors.white,
      child: Text(
        grade,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    final student = _selectedStudent!;
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startWeekday =
        firstDayOfMonth.weekday % 7; // Make Sunday 0 instead of 7

    // Get the records for the current month
    final monthRecords = student.records.where((record) {
      // Also include records for days shown from previous/next month
      return record.date.month == _currentMonth.month ||
          (record.date.day <= 7 &&
              record.date.month == _currentMonth.month + 1) ||
          (record.date.day >= 23 &&
              record.date.month == _currentMonth.month - 1);
    }).toList();

    // Build calendar days (including those from previous/next month that appear on the calendar)
    final calendarDays = <DateTime>[];

    // Add days from previous month
    for (int i = 0; i < startWeekday; i++) {
      calendarDays
          .add(firstDayOfMonth.subtract(Duration(days: startWeekday - i)));
    }

    // Add days from current month
    for (int i = 0; i < daysInMonth; i++) {
      calendarDays
          .add(DateTime(_currentMonth.year, _currentMonth.month, i + 1));
    }

    // Add days from next month to complete the grid
    final remainingDays = 42 - calendarDays.length;
    for (int i = 1; i <= remainingDays; i++) {
      calendarDays
          .add(DateTime(_currentMonth.year, _currentMonth.month + 1, i));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Top action bar with export/back button and navigation
          Container(
            height: 50,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button and export
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedStudent = null;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Export functionality
                      },
                      icon: const Icon(Icons.download, size: 14),
                      label:
                          const Text('Export', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        minimumSize: const Size(0, 24),
                      ),
                    ),
                  ],
                ),

                // Month/Year and navigation
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                              _currentMonth.year, _currentMonth.month - 1, 1);
                        });
                      },
                    ),
                    // Month dropdown
                    InkWell(
                      onTap: () => _showMonthSelectionDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('MMMM').format(_currentMonth),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Year dropdown
                    InkWell(
                      onTap: () => _showYearSelectionDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _currentMonth.year.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 14),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                              _currentMonth.year, _currentMonth.month + 1, 1);
                        });
                      },
                    ),
                  ],
                ),

                // Empty space to balance the layout
                const SizedBox(width: 50),
              ],
            ),
          ),

          // Student info - more compact
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: AssetImage(student.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 6),
                Text(
                  student.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(width: 4),
                Text(
                  '${student.grade} • ${student.section}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),

          // Calendar - use rest of the space
          Expanded(
            child: Container(
              color: const Color(0xFFF0F4F9),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Column(
                children: [
                  // Days of week header - smaller height
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildDayHeader('Sun'),
                        _buildDayHeader('Mon'),
                        _buildDayHeader('Tue'),
                        _buildDayHeader('Wed'),
                        _buildDayHeader('Thu'),
                        _buildDayHeader('Fri'),
                        _buildDayHeader('Sat'),
                      ],
                    ),
                  ),

                  // Calendar grid - using LayoutBuilder to fit available space
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      // Calculate optimal cell height to fit all rows without scrolling
                      final double availableHeight = constraints.maxHeight -
                          2; // small adjustment for borders
                      final double cellHeight = availableHeight / 6; // 6 weeks

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio:
                              constraints.maxWidth / 7 / cellHeight,
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,
                        ),
                        itemCount: calendarDays.length,
                        itemBuilder: (context, index) {
                          final day = calendarDays[index];
                          final isCurrentMonth =
                              day.month == _currentMonth.month;

                          // Find the attendance record for this day
                          final AttendanceRecord record =
                              monthRecords.firstWhere(
                            (r) =>
                                r.date.year == day.year &&
                                r.date.month == day.month &&
                                r.date.day == day.day,
                            orElse: () => AttendanceRecord(
                              id: '',
                              studentId: student.id,
                              date: day,
                              dropOffTime: const TimeOfDay(hour: 0, minute: 0),
                              pickupTime: const TimeOfDay(hour: 0, minute: 0),
                              isPresent: false,
                            ),
                          );

                          return _buildCalendarCell(
                              day, record, isCurrentMonth);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Legend - smaller height
          Container(
            height: 30,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Present', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 16),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Absent', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    String period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
    int hour = timeOfDay.hour > 12 ? timeOfDay.hour - 12 : timeOfDay.hour;
    hour = hour == 0 ? 12 : hour; // Convert 0 to 12 for 12 AM
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Widget _buildCalendarCell(
      DateTime day, AttendanceRecord? record, bool isCurrentMonth) {
    final bool hasRecord = record != null && record.id.isNotEmpty;
    final bool isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    Color cellColor = Colors.white;
    if (!isCurrentMonth) {
      cellColor = const Color(0xFFF8F9FA);
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        border: Border.all(color: Colors.grey.shade100, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day number row with status indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day number
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 2),
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCurrentMonth ? Colors.black : Colors.grey.shade400,
                  ),
                ),
              ),

              // Status indicator
              if (hasRecord && !isWeekend)
                Padding(
                  padding: const EdgeInsets.only(right: 4, top: 2),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: record!.isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),

          // Spacer
          const Spacer(),

          // Attendance info - simplified to save space
          if (hasRecord && !isWeekend && isCurrentMonth)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 2, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drop: ${_formatTimeOfDay(record!.dropOffTime)}',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    'Pick: ${_formatTimeOfDay(record.pickupTime)}',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGradeFilterButton(String text, {bool hasDropdown = false}) {
    final bool isSelected = _selectedGrade == text ||
        (text == 'Grade 1-6' && _selectedGrade.startsWith('Grade'));

    return ElevatedButton(
      onPressed: () {
        if (hasDropdown) {
          _showGradeSelectionMenu(context);
        } else {
          setState(() {
            _selectedGrade = text;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Text(text),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ],
      ),
    );
  }

  void _showGradeSelectionMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(200, 100, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'Grade 1',
          child: Text('Grade 1'),
        ),
        const PopupMenuItem<String>(
          value: 'Grade 2',
          child: Text('Grade 2'),
        ),
        const PopupMenuItem<String>(
          value: 'Grade 3',
          child: Text('Grade 3'),
        ),
        const PopupMenuItem<String>(
          value: 'Grade 4',
          child: Text('Grade 4'),
        ),
        const PopupMenuItem<String>(
          value: 'Grade 5',
          child: Text('Grade 5'),
        ),
        const PopupMenuItem<String>(
          value: 'Grade 6',
          child: Text('Grade 6'),
        ),
      ],
    ).then((String? value) {
      if (value != null) {
        setState(() {
          _selectedGrade = value;
        });
      }
    });
  }

  // New method to show month selection dialog
  void _showMonthSelectionDialog() {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: Container(
            width: double.minPositive,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: months.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(months[index]),
                  selected: _currentMonth.month == index + 1,
                  selectedTileColor: Colors.green.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _currentMonth =
                          DateTime(_currentMonth.year, index + 1, 1);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // New method to show year selection dialog
  void _showYearSelectionDialog() {
    final int currentYear = DateTime.now().year;
    final List<int> years =
        List.generate(10, (index) => currentYear - 5 + index);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: Container(
            width: double.minPositive,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: years.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(years[index].toString()),
                  selected: _currentMonth.year == years[index],
                  selectedTileColor: Colors.green.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _currentMonth =
                          DateTime(years[index], _currentMonth.month, 1);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
