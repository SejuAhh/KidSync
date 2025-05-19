import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';
import 'student_management.dart';
import 'parent_guardian.dart';
import 'attendance.dart';
import 'audit_logs.dart';

class User {
  final String id;
  String name;
  String role;
  String email;
  String phone;
  bool isActive;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.isActive,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User(
      id: 'T001',
      name: 'John Smith',
      role: 'Teacher',
      email: 'john.smith@school.com',
      phone: '+1 234-567-8901',
      isActive: true,
    ),
    User(
      id: 'P001',
      name: 'Mary Johnson',
      role: 'Parent',
      email: 'mary.j@email.com',
      phone: '+1 234-567-8902',
      isActive: true,
    ),
    User(
      id: 'D001',
      name: 'Robert Davis',
      role: 'Driver',
      email: 'robert.d@school.com',
      phone: '+1 234-567-8903',
      isActive: false,
    ),
    User(
      id: 'G001',
      name: 'Sarah Wilson',
      role: 'Guard',
      email: 'sarah.w@school.com',
      phone: '+1 234-567-8904',
      isActive: true,
    ),
    User(
      id: 'T002',
      name: 'James Brown',
      role: 'Teacher',
      email: 'james.b@school.com',
      phone: '+1 234-567-8905',
      isActive: true,
    ),
    User(
      id: 'P002',
      name: 'Patricia Moore',
      role: 'Parent',
      email: 'patricia.m@email.com',
      phone: '+1 234-567-8906',
      isActive: true,
    ),
    User(
      id: 'D002',
      name: 'Michael Lee',
      role: 'Driver',
      email: 'michael.l@school.com',
      phone: '+1 234-567-8907',
      isActive: true,
    ),
    User(
      id: 'G002',
      name: 'Linda Taylor',
      role: 'Guard',
      email: 'linda.t@school.com',
      phone: '+1 234-567-8908',
      isActive: false,
    ),
  ];

  String _searchQuery = '';
  String _selectedRole = 'All Roles';
  int _currentPage = 1;
  final int _itemsPerPage = 8;

  void _onDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u.id == user.id);
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

  void _onToggleStatus(User user) {
    setState(() {
      user.isActive = !user.isActive;
    });
  }

  void _onExport() {
    // Create CSV content
    final csvData = StringBuffer();
    csvData.writeln('User ID,Name,Role,Email,Phone,Status');

    for (final user in _filteredUsers) {
      csvData.writeln(
          '${user.id},${user.name},${user.role},${user.email},${user.phone},${user.isActive ? "Active" : "Inactive"}');
    }

    // Show success message with copy option
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Success'),
        content: const Text(
            'User data has been prepared for export. Would you like to copy it to clipboard?'),
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

  void _onEdit(User user) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    String selectedRole = user.role;
    String selectedImagePath =
        'assets/profiles/default.png'; // Default, in a real app would use user's image

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User: ${user.name}'),
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
                // Name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                // Role dropdown
                DropdownButtonFormField(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                  items: ['Teacher', 'Parent', 'Driver', 'Guard']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    selectedRole = value.toString();
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
                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
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
                setState(() {
                  user.name = nameController.text;
                  user.role = selectedRole;
                  user.email = emailController.text;
                  user.phone = phoneController.text;
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
                          Text('User ${user.name} updated successfully'),
                        ],
                      ),
                    );
                  },
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addNewUser() {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedRole = 'Teacher';
    String selectedImagePath = 'assets/profiles/default.png';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
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
                // User ID
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user ID';
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
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                // Role dropdown
                DropdownButtonFormField(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                  items: ['Teacher', 'Parent', 'Driver', 'Guard']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) {
                    selectedRole = value.toString();
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
                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
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
                final newUser = User(
                  id: idController.text,
                  name: nameController.text,
                  role: selectedRole,
                  email: emailController.text,
                  phone: phoneController.text,
                  isActive: true,
                );

                setState(() {
                  _users.add(newUser);
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
                          Text('User ${newUser.name} added successfully'),
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

  List<User> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.phone.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesRole =
          _selectedRole == 'All Roles' || user.role == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  List<User> get _paginatedUsers {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _filteredUsers.length) {
      return [];
    }
    return _filteredUsers.sublist(startIndex,
        endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex);
  }

  int get _totalPages => (_filteredUsers.length / _itemsPerPage).ceil();

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
                  isSelected: true,
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
                  // User Management content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Search bar
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search users...',
                                    prefixIcon: const Icon(Icons.search,
                                        color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                      _currentPage = 1;
                                    });
                                  },
                                ),
                              ),

                              Row(
                                children: [
                                  // Role filter
                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedRole,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: [
                                          'All Roles',
                                          'Teacher',
                                          'Parent',
                                          'Driver',
                                          'Guard'
                                        ].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedRole = value!;
                                            _currentPage = 1;
                                          });
                                        },
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Add New User Button
                                  ElevatedButton.icon(
                                    onPressed: _addNewUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add New User'),
                                  ),

                                  // Export Button
                                  const SizedBox(width: 10),
                                  OutlinedButton.icon(
                                    onPressed: _onExport,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      side:
                                          const BorderSide(color: Colors.grey),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    icon: const Icon(
                                        Icons.file_download_outlined),
                                    label: const Text('Export'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Users Table
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
                                                  label: Text('User ID')),
                                              DataColumn(label: Text('Name')),
                                              DataColumn(label: Text('Role')),
                                              DataColumn(label: Text('Email')),
                                              DataColumn(label: Text('Phone')),
                                              DataColumn(label: Text('Status')),
                                              DataColumn(
                                                  label: Text('Actions')),
                                            ],
                                            rows: _paginatedUsers.map((user) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(Text(user.id)),
                                                  DataCell(Text(user.name)),
                                                  DataCell(Text(user.role)),
                                                  DataCell(Text(user.email)),
                                                  DataCell(Text(user.phone)),
                                                  DataCell(
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: user.isActive
                                                            ? Colors
                                                                .green.shade50
                                                            : Colors
                                                                .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        user.isActive
                                                            ? 'Active'
                                                            : 'Inactive',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: user.isActive
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
                                                          icon: const Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.blue,
                                                              size: 20),
                                                          onPressed: () =>
                                                              _onEdit(user),
                                                          constraints:
                                                              const BoxConstraints(),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          tooltip: 'Edit',
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                              size: 20),
                                                          onPressed: () =>
                                                              _onDelete(user),
                                                          constraints:
                                                              const BoxConstraints(),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
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
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Showing 1 to ${_paginatedUsers.length} of ${_filteredUsers.length} entries'),
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: _currentPage > 1
                                                  ? () => setState(
                                                      () => _currentPage--)
                                                  : null,
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    _currentPage > 1
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                              child: const Text('Previous'),
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
                                                    minimumSize:
                                                        const Size(40, 40),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                  child: Text('$i'),
                                                ),
                                              ),
                                            TextButton(
                                              onPressed:
                                                  _currentPage < _totalPages
                                                      ? () => setState(
                                                          () => _currentPage++)
                                                      : null,
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    _currentPage < _totalPages
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                              child: const Text('Next'),
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
}
