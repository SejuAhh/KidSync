import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';
import 'user_management.dart';
import 'parent_guardian.dart';
import 'attendance.dart';
import 'audit_logs.dart';

class Student {
  final String id;
  final String name;
  final String className;
  final String gender;
  final String contactNumber;
  final String email;
  final String enrollmentDate;
  bool isActive;

  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.gender,
    required this.contactNumber,
    required this.email,
    required this.enrollmentDate,
    required this.isActive,
  });
}

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final List<Student> _students = [
    Student(
      id: 'STU001',
      name: 'Alex Thompson',
      className: 'Preschool',
      gender: 'Male',
      contactNumber: '+1 234 567 890',
      email: 'alex.t@email.com',
      enrollmentDate: '2023-09-01',
      isActive: true,
    ),
    Student(
      id: 'STU002',
      name: 'Emma Wilson',
      className: 'Kindergarten',
      gender: 'Female',
      contactNumber: '+1 234 567 891',
      email: 'emma.w@email.com',
      enrollmentDate: '2023-09-02',
      isActive: true,
    ),
    Student(
      id: 'STU003',
      name: 'James Miller',
      className: 'Grade 1',
      gender: 'Male',
      contactNumber: '+1 234 567 892',
      email: 'james.m@email.com',
      enrollmentDate: '2023-09-03',
      isActive: false,
    ),
    Student(
      id: 'STU004',
      name: 'Sophia Davis',
      className: 'Grade 3',
      gender: 'Female',
      contactNumber: '+1 234 567 893',
      email: 'sophia.d@email.com',
      enrollmentDate: '2023-09-04',
      isActive: true,
    ),
    Student(
      id: 'STU005',
      name: 'William Brown',
      className: 'Grade 6',
      gender: 'Male',
      contactNumber: '+1 234 567 894',
      email: 'william.b@email.com',
      enrollmentDate: '2023-09-05',
      isActive: true,
    ),
  ];

  String _searchQuery = '';
  String _selectedClass = 'All Classes';
  String _selectedStatus = 'All Status';
  String _sortBy = 'Name (A-Z)';
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  void _onDelete(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _students.removeWhere((s) => s.id == student.id);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onToggleStatus(Student student) {
    setState(() {
      student.isActive = !student.isActive;
    });
  }

  List<Student> get _filteredStudents {
    return _students.where((student) {
      final matchesSearch =
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              student.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              student.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesClass = _selectedClass == 'All Classes' ||
          student.className.contains(_selectedClass);

      final matchesStatus = _selectedStatus == 'All Status' ||
          (student.isActive && _selectedStatus == 'Active') ||
          (!student.isActive && _selectedStatus == 'Inactive');

      return matchesSearch && matchesClass && matchesStatus;
    }).toList();
  }

  List<Student> get _paginatedStudents {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredStudents.length) {
      return [];
    }
    return _filteredStudents.sublist(
        startIndex,
        endIndex > _filteredStudents.length
            ? _filteredStudents.length
            : endIndex);
  }

  int get _totalPages => (_filteredStudents.length / _itemsPerPage).ceil();

  void _onExport() {
    // Create CSV content
    final csvData = StringBuffer();
    csvData.writeln(
        'Student ID,Name,Class,Gender,Contact Number,Email,Enrollment Date,Status');

    for (final student in _filteredStudents) {
      csvData.writeln(
          '${student.id},${student.name},${student.className},${student.gender},'
          '${student.contactNumber},${student.email},${student.enrollmentDate},'
          '${student.isActive ? "Active" : "Inactive"}');
    }

    // Show success message with copy option
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Success'),
        content: const Text(
            'Student data has been prepared for export. Would you like to copy it to clipboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csvData.toString()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data copied to clipboard')),
              );
              Navigator.pop(context);
            },
            child: const Text('Copy to Clipboard'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, this would trigger a file download
              Clipboard.setData(ClipboardData(text: csvData.toString()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Data copied and would be downloaded in a real app')),
              );
              Navigator.pop(context);
            },
            child: const Text('Download CSV'),
          ),
        ],
      ),
    );
  }

  void _addNewStudent() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    String selectedGender = 'Male';
    String selectedClass = 'Preschool';
    String selectedImagePath = 'assets/profiles/default.png';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Student'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image selection
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(selectedImagePath),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                            onPressed: () {
                              // Show image selection options
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Select Image Source'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          // In a real app, this would open the gallery
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo_camera),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          // In a real app, this would open the camera
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 30, minHeight: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Student ID
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a student ID';
                    }
                    return null;
                  },
                ),
                // Name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter student name';
                    }
                    return null;
                  },
                ),
                // Class dropdown
                DropdownButtonFormField(
                  value: selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                  ),
                  items: [
                    'Preschool',
                    'Kindergarten',
                    'Grade 1',
                    'Grade 2',
                    'Grade 3',
                    'Grade 4',
                    'Grade 5',
                    'Grade 6'
                  ]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    selectedClass = value.toString();
                  },
                ),
                // Gender dropdown
                DropdownButtonFormField(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                  ),
                  items: ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) {
                    selectedGender = value.toString();
                  },
                ),
                // Contact
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                ),
                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newStudent = Student(
                  id: idController.text,
                  name: nameController.text,
                  className: selectedClass,
                  gender: selectedGender,
                  contactNumber: contactController.text,
                  email: emailController.text,
                  enrollmentDate:
                      DateTime.now().toString().split(' ')[0], // Today's date
                  isActive: true,
                );

                setState(() {
                  _students.add(newStudent);
                });

                Navigator.pop(context);

                // Show centered notification
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    // Auto-dismiss after 2 seconds
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });

                    return AlertDialog(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 10),
                          Text('Student ${newStudent.name} added successfully'),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
                  isSelected: true,
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AttendanceScreen()),
                    );
                  },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Student Management content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Student Management',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardScreen()),
                                  );
                                },
                                child: const Text(
                                  'Home',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const Text(' / ',
                                  style: TextStyle(color: Colors.grey)),
                              const Text(
                                'Student Management',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Search and filter bar
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.search,
                                          color: Colors.grey),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Search students...',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _searchQuery = value;
                                              _currentPage =
                                                  1; // Reset to first page on search
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _addNewStudent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Student'),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: _onExport,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.grey),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                icon: const Icon(Icons.file_download_outlined),
                                label: const Text('Export'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Filter buttons
                          Row(
                            children: [
                              _buildFilterButton(
                                text: _selectedClass,
                                options: [
                                  'All Classes',
                                  'Preschool',
                                  'Kindergarten',
                                  'Grade 1',
                                  'Grade 2',
                                  'Grade 3',
                                  'Grade 4',
                                  'Grade 5',
                                  'Grade 6'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedClass = value!;
                                    _currentPage =
                                        1; // Reset to first page on filter change
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _buildFilterButton(
                                text: _selectedStatus,
                                options: ['All Status', 'Active', 'Inactive'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStatus = value!;
                                    _currentPage =
                                        1; // Reset to first page on filter change
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _buildFilterButton(
                                text: _sortBy,
                                options: [
                                  'Name (A-Z)',
                                  'Name (Z-A)',
                                  'ID (Asc)',
                                  'ID (Desc)'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _sortBy = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Students table
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Table with DataTable for better alignment
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                270,
                                          ),
                                          child: DataTable(
                                            headingTextStyle: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Student ID')),
                                              DataColumn(
                                                  label: Text('Student Name')),
                                              DataColumn(label: Text('Class')),
                                              DataColumn(label: Text('Gender')),
                                              DataColumn(
                                                  label:
                                                      Text('Contact Number')),
                                              DataColumn(label: Text('Email')),
                                              DataColumn(
                                                  label:
                                                      Text('Enrollment Date')),
                                              DataColumn(label: Text('Status')),
                                              DataColumn(
                                                  label: Text('Actions')),
                                            ],
                                            rows: _paginatedStudents
                                                .map((student) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(Text(student.id)),
                                                  DataCell(Text(student.name)),
                                                  DataCell(
                                                      Text(student.className)),
                                                  DataCell(
                                                      Text(student.gender)),
                                                  DataCell(Text(
                                                      student.contactNumber)),
                                                  DataCell(Text(student.email)),
                                                  DataCell(Text(
                                                      student.enrollmentDate)),
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: student.isActive
                                                            ? Colors
                                                                .green.shade50
                                                            : Colors
                                                                .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        student.isActive
                                                            ? 'Active'
                                                            : 'Inactive',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              student.isActive
                                                                  ? Colors.green
                                                                  : Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () =>
                                                              _onToggleStatus(
                                                                  student),
                                                          icon: Icon(
                                                            student.isActive
                                                                ? Icons
                                                                    .toggle_on
                                                                : Icons
                                                                    .toggle_off,
                                                            color: student
                                                                    .isActive
                                                                ? Colors.green
                                                                : Colors.grey,
                                                          ),
                                                          tooltip:
                                                              student.isActive
                                                                  ? 'Deactivate'
                                                                  : 'Activate',
                                                        ),
                                                        IconButton(
                                                          onPressed: () =>
                                                              _onDelete(
                                                                  student),
                                                          icon: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color:
                                                                  Colors.red),
                                                          tooltip: 'Delete',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Pagination
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Showing 1 to ${_paginatedStudents.length} of ${_filteredStudents.length} entries'),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: _currentPage > 1
                                                  ? () => setState(
                                                      () => _currentPage--)
                                                  : null,
                                              icon: const Icon(
                                                  Icons.chevron_left),
                                            ),
                                            for (int i = 1;
                                                i <= _totalPages;
                                                i++)
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentPage = i;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        _currentPage == i
                                                            ? Colors.green
                                                            : Colors.white,
                                                    foregroundColor:
                                                        _currentPage == i
                                                            ? Colors.white
                                                            : Colors.black,
                                                    elevation: 0,
                                                    minimumSize:
                                                        const Size(40, 40),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Text('$i'),
                                                ),
                                              ),
                                            IconButton(
                                              onPressed:
                                                  _currentPage < _totalPages
                                                      ? () => setState(
                                                          () => _currentPage++)
                                                      : null,
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

  Widget _buildFilterButton({
    required String text,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: text,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
