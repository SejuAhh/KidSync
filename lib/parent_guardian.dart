import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'student_management.dart';
import 'user_management.dart';
import 'attendance.dart';
import 'audit_logs.dart';

class ParentGuardian {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String imageUrl;
  final List<AssociatedStudent> students;

  ParentGuardian({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.imageUrl,
    required this.students,
  });
}

class AssociatedStudent {
  final String name;
  final String grade;
  final String section;
  final List<Contact> fetchers;
  final List<Contact> drivers;
  final List<Contact> guardians;

  AssociatedStudent({
    required this.name,
    required this.grade,
    required this.section,
    required this.fetchers,
    required this.drivers,
    required this.guardians,
  });
}

class Contact {
  final String name;
  final String role;
  final String imageUrl;

  Contact({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class ParentGuardianScreen extends StatefulWidget {
  const ParentGuardianScreen({super.key});

  @override
  State<ParentGuardianScreen> createState() => _ParentGuardianScreenState();
}

class _ParentGuardianScreenState extends State<ParentGuardianScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ParentGuardian> _parents = [
    ParentGuardian(
      id: 'P001',
      name: 'John Smith',
      phone: '+1 (555) 123-4567',
      email: 'john.smith@email.com',
      imageUrl: 'assets/profiles/male1.png',
      students: [
        AssociatedStudent(
          name: 'Sarah Smith',
          grade: 'Grade 5',
          section: 'Section A',
          fetchers: [
            Contact(
              name: 'Mary Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/female1.png',
            ),
            Contact(
              name: 'David Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male2.png',
            ),
            Contact(
              name: 'Emma Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/female2.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
            Contact(
              name: 'Mike Johnson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male4.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Emma Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female2.png',
            ),
            Contact(
              name: 'Sarah Wilson',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female3.png',
            ),
          ],
        ),
        AssociatedStudent(
          name: 'Michael Smith',
          grade: 'Grade 3',
          section: 'Section B',
          fetchers: [
            Contact(
              name: 'Mary Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/female1.png',
            ),
            Contact(
              name: 'David Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male2.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Emma Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female2.png',
            ),
          ],
        ),
      ],
    ),
    ParentGuardian(
      id: 'P002',
      name: 'John Smith',
      phone: '+1 (555) 123-4567',
      email: 'john.s@email.com',
      imageUrl: 'assets/profiles/male5.png',
      students: [
        AssociatedStudent(
          name: 'Emma Smith',
          grade: 'Grade 2',
          section: 'Section C',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male5.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Lisa Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female4.png',
            ),
          ],
        ),
        AssociatedStudent(
          name: 'Jacob Smith',
          grade: 'Kindergarten',
          section: 'Section A',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male5.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Lisa Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female4.png',
            ),
          ],
        ),
      ],
    ),
    // Add more parents as needed
    ParentGuardian(
      id: 'P003',
      name: 'John Smith',
      phone: '+1 (555) 123-4567',
      email: 'j.smith@email.com',
      imageUrl: 'assets/profiles/male6.png',
      students: [
        AssociatedStudent(
          name: 'Olivia Smith',
          grade: 'Grade 1',
          section: 'Section A',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male6.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'Mike Johnson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male4.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Anna Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female5.png',
            ),
          ],
        ),
        AssociatedStudent(
          name: 'James Smith',
          grade: 'Preschool',
          section: 'Section B',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/male6.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'Mike Johnson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male4.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Anna Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female5.png',
            ),
          ],
        ),
      ],
    ),
    ParentGuardian(
      id: 'P004',
      name: 'John Smith',
      phone: '+1 (555) 123-4567',
      email: 'john@email.com',
      imageUrl: 'assets/profiles/female6.png',
      students: [
        AssociatedStudent(
          name: 'Daniel Smith',
          grade: 'Grade 4',
          section: 'Section B',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/female6.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Kate Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female7.png',
            ),
          ],
        ),
        AssociatedStudent(
          name: 'Sophia Smith',
          grade: 'Grade 6',
          section: 'Section A',
          fetchers: [
            Contact(
              name: 'John Smith',
              role: 'Fetcher',
              imageUrl: 'assets/profiles/female6.png',
            ),
          ],
          drivers: [
            Contact(
              name: 'James Wilson',
              role: 'Driver',
              imageUrl: 'assets/profiles/male3.png',
            ),
          ],
          guardians: [
            Contact(
              name: 'Kate Smith',
              role: 'Guardian',
              imageUrl: 'assets/profiles/female7.png',
            ),
          ],
        ),
      ],
    ),
  ];

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
                  isSelected: true,
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
                  // Search and Add New Parent button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(right: 16),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search parents...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(0),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showAddParentDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Parent'),
                        ),
                      ],
                    ),
                  ),
                  // Parents grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: _parents.length,
                        itemBuilder: (context, index) {
                          return _buildParentCard(_parents[index]);
                        },
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

  Widget _buildParentCard(ParentGuardian parent) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage(parent.imageUrl),
                onBackgroundImageError: (_, __) {},
                child: Text(
                  parent.name.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                parent.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Text(
                parent.phone,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                '${parent.students.length} Students',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _showParentDetails(context, parent),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View Details'),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showParentDetails(BuildContext context, ParentGuardian parent) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: AssetImage(parent.imageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: Text(
                      parent.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Parent',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        parent.email,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Associated Students',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: parent.students
                        .map((student) => _buildStudentItem(context, student))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentItem(BuildContext context, AssociatedStudent student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              student.name.substring(0, 1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            student.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('${student.grade} - ${student.section}'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactsRow('Fetchers:', student.fetchers),
              _buildContactsRow('Drivers:', student.drivers),
              _buildContactsRow('Guardians:', student.guardians),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 10),
          child: TextButton(
            onPressed: () => _showMoreDetails(context, student),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: Colors.green,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('View more'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildContactsRow(String label, List<Contact> contacts) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              contacts.map((c) => c.name).join(', '),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreDetails(BuildContext context, AssociatedStudent student) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...student.fetchers.isNotEmpty
                    ? [
                        const Text(
                          'Fetcher',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...student.fetchers
                            .map((contact) => _buildContactItem(contact)),
                        const SizedBox(height: 15),
                      ]
                    : [],
                ...student.guardians.isNotEmpty
                    ? [
                        const Text(
                          'Guardian',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...student.guardians
                            .map((contact) => _buildContactItem(contact)),
                        const SizedBox(height: 15),
                      ]
                    : [],
                ...student.drivers.isNotEmpty
                    ? [
                        const Text(
                          'Driver',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...student.drivers
                            .map((contact) => _buildContactItem(contact)),
                      ]
                    : [],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(Contact contact) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Text(
          contact.name.substring(0, 1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.role),
    );
  }

  void _showAddParentDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Parent'),
        content: SizedBox(
          width: 400,
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
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.grey),
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
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter parent name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 20),
                _buildAssociatedStudentSection(context),
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

                    return const AlertDialog(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 10),
                          Text('New parent added successfully'),
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

  Widget _buildAssociatedStudentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Associated Students',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              _buildStudentRow(),
              _buildStudentRow(),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Another Student'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Student',
            ),
            items: ['Sarah Smith', 'Michael Smith', 'Emma Smith', 'Jacob Smith']
                .map((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    ))
                .toList(),
            onChanged: (value) {},
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ],
    );
  }
}
