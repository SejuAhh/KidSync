import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dashboard.dart';
import 'student_management.dart';
import 'user_management.dart';
import 'parent_guardian.dart';
import 'attendance.dart';

class AuditLog {
  final DateTime timestamp;
  final String userName;
  final String userRole;
  final String action;
  final String module;
  final bool isSuccess;
  final String details;
  final String id;

  AuditLog({
    required this.timestamp,
    required this.userName,
    required this.userRole,
    required this.action,
    required this.module,
    required this.isSuccess,
    required this.details,
    required this.id,
  });
}

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTimeRange? _selectedDateRange;
  String _selectedFilter = 'All Actions';

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  // Sample data for audit logs
  final List<AuditLog> _auditLogs = [
    AuditLog(
      timestamp: DateTime(2024, 1, 20, 10, 15),
      userName: 'Mary Johnson',
      userRole: 'Admin',
      action: 'Created new class',
      module: 'Class Management',
      isSuccess: true,
      details: 'Created Class 5B for Academic Year 2024',
      id: 'LOG001',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 20, 11, 0),
      userName: 'Robert Wilson',
      userRole: 'Guard',
      action: 'dadawdawdawd',
      module: 'dadadaw',
      isSuccess: true,
      details: 'Accessed attendance history for Student ID: 5878',
      id: 'LOG002',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 20, 11, 45),
      userName: 'Sarah Davis',
      userRole: 'Teacher',
      action: 'Marked attendance',
      module: 'Attendance',
      isSuccess: true,
      details: 'Marked attendance for Class 3A',
      id: 'LOG003',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 20, 13, 20),
      userName: 'James Brown',
      userRole: 'Admin',
      action: 'Deleted user account',
      module: 'User Management',
      isSuccess: false,
      details: 'Removed inactive user account ID: 9012',
      id: 'LOG004',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 19, 9, 30),
      userName: 'Emma Wilson',
      userRole: 'Admin',
      action: 'Updated system settings',
      module: 'System',
      isSuccess: true,
      details: 'Changed notification settings',
      id: 'LOG005',
    ),
    // Additional logs
    AuditLog(
      timestamp: DateTime(2024, 1, 18, 15, 10),
      userName: 'Michael Clark',
      userRole: 'Teacher',
      action: 'Generated report',
      module: 'Reports',
      isSuccess: true,
      details: 'Generated attendance report for January 2024',
      id: 'LOG006',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 18, 10, 0),
      userName: 'Jennifer Lee',
      userRole: 'Admin',
      action: 'Added new student',
      module: 'Student Management',
      isSuccess: true,
      details: 'Added new student: Alice Johnson',
      id: 'LOG007',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 17, 14, 25),
      userName: 'David Miller',
      userRole: 'Parent',
      action: 'Accessed profile',
      module: 'Parent Portal',
      isSuccess: true,
      details: 'Viewed student progress report',
      id: 'LOG008',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 17, 9, 15),
      userName: 'Lisa Taylor',
      userRole: 'Teacher',
      action: 'Updated grades',
      module: 'Academic',
      isSuccess: true,
      details: 'Updated grades for Math class',
      id: 'LOG009',
    ),
    AuditLog(
      timestamp: DateTime(2024, 1, 16, 11, 35),
      userName: 'George Wilson',
      userRole: 'Admin',
      action: 'Reset password',
      module: 'User Management',
      isSuccess: false,
      details: 'Failed to reset password for user ID: 3045',
      id: 'LOG010',
    ),
  ];

  List<AuditLog> get _filteredLogs {
    return _auditLogs.where((log) {
      final matchesSearch =
          log.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              log.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              log.module.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              log.details.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDateRange = _selectedDateRange == null ||
          (log.timestamp.isAfter(_selectedDateRange!.start) &&
              log.timestamp.isBefore(
                  _selectedDateRange!.end.add(const Duration(days: 1))));

      final matchesFilter = _selectedFilter == 'All Actions' ||
          (_selectedFilter == 'System Changes' && log.module == 'System') ||
          (_selectedFilter == 'User Actions' &&
              log.module == 'User Management') ||
          (_selectedFilter == 'Student Records' &&
              log.module == 'Student Management') ||
          (_selectedFilter == 'Attendance Records' &&
              log.module == 'Attendance');

      return matchesSearch && matchesDateRange && matchesFilter;
    }).toList();
  }

  List<AuditLog> get _paginatedLogs {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    if (startIndex >= _filteredLogs.length) {
      return [];
    }
    final endIndex = min(startIndex + _itemsPerPage, _filteredLogs.length);
    return _filteredLogs.sublist(startIndex, endIndex);
  }

  int get _totalPages => (_filteredLogs.length / _itemsPerPage).ceil();

  void _showDateRangePicker() async {
    final initialDateRange = _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
        _currentPage = 1; // Reset to first page after applying filter
      });
    }
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Logs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All Actions'),
            _buildFilterOption('System Changes'),
            _buildFilterOption('User Actions'),
            _buildFilterOption('Student Records'),
            _buildFilterOption('Attendance Records'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    return ListTile(
      title: Text(filter),
      leading: Radio<String>(
        value: filter,
        groupValue: _selectedFilter,
        onChanged: (value) {
          setState(() {
            _selectedFilter = value!;
            _currentPage = 1; // Reset to first page
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _exportLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logs exported successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogDetails(AuditLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('ID', log.id),
            _buildDetailRow('Timestamp',
                DateFormat('yyyy-MM-dd HH:mm').format(log.timestamp)),
            _buildDetailRow('User', '${log.userName} (${log.userRole})'),
            _buildDetailRow('Action', log.action),
            _buildDetailRow('Module', log.module),
            _buildDetailRow('Status', log.isSuccess ? 'Success' : 'Failed'),
            _buildDetailRow('Details', log.details),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 185,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'KidSync',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                _buildSidebarItem(
                  icon: Icons.dashboard_outlined,
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
                  icon: Icons.people_outline,
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
                  icon: Icons.person_outline,
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
                  icon: Icons.family_restroom_outlined,
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
                  icon: Icons.calendar_today_outlined,
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
                  icon: Icons.description_outlined,
                  title: 'Audit Logs',
                  isSelected: true,
                ),
                const Spacer(),
                _buildSidebarItem(
                  icon: Icons.logout_outlined,
                  title: 'Log Out',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
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
                  // Search and filters area
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Search bar
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search logs...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _currentPage = 1;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Date range button
                        OutlinedButton.icon(
                          onPressed: _showDateRangePicker,
                          icon: const Icon(Icons.calendar_today_outlined,
                              size: 18),
                          label: Row(
                            children: [
                              Text(
                                _selectedDateRange == null
                                    ? 'Date Range'
                                    : '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Filter button
                        OutlinedButton.icon(
                          onPressed: _showFilterOptions,
                          icon:
                              const Icon(Icons.filter_list_outlined, size: 18),
                          label: Row(
                            children: [
                              Text(
                                'Filters',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Export button
                        OutlinedButton.icon(
                          onPressed: _exportLogs,
                          icon: const Icon(Icons.file_download_outlined,
                              size: 18),
                          label: const Text(
                            'Export',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main table content area
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade100),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text('Timestamp',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 3,
                                    child: Text('User',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 3,
                                    child: Text('Action',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 3,
                                    child: Text('Module',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 1,
                                    child: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                Expanded(
                                    flex: 5,
                                    child: Text('Details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                                SizedBox(
                                    width: 40,
                                    child: Text('',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),

                          // Table content
                          Expanded(
                            child: _paginatedLogs.isEmpty
                                ? const Center(
                                    child: Text('No logs found'),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: _paginatedLogs.length,
                                    separatorBuilder: (_, __) => Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey.shade100,
                                    ),
                                    itemBuilder: (context, index) {
                                      final log = _paginatedLogs[index];
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            // Timestamp
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Jan ${log.timestamp.day}, ${log.timestamp.year}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // User
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    log.userName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    log.userRole,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Action
                                            Expanded(
                                              flex: 3,
                                              child: Text(log.action),
                                            ),

                                            // Module
                                            Expanded(
                                              flex: 3,
                                              child: Text(log.module),
                                            ),

                                            // Status
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: log.isSuccess
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ),

                                            // Details
                                            Expanded(
                                              flex: 5,
                                              child: Text(
                                                log.details,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                            // Actions
                                            SizedBox(
                                              width: 40,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                                onPressed: () =>
                                                    _showLogDetails(log),
                                                splashRadius: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          // Pagination
                          if (_filteredLogs.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey.shade100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Showing 1 to ${min(_paginatedLogs.length, _itemsPerPage)} of ${_filteredLogs.length} entries',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Spacer(),
                                  OutlinedButton(
                                    onPressed: _currentPage > 1
                                        ? () {
                                            setState(() {
                                              _currentPage--;
                                            });
                                          }
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      foregroundColor: Colors.black87,
                                    ),
                                    child: Text('Previous'),
                                  ),
                                  const SizedBox(width: 8),
                                  for (int i = 1; i <= min(_totalPages, 4); i++)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentPage = i;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          backgroundColor: _currentPage == i
                                              ? Colors.green
                                              : Colors.white,
                                          foregroundColor: _currentPage == i
                                              ? Colors.white
                                              : Colors.black87,
                                          side: BorderSide(
                                            color: _currentPage == i
                                                ? Colors.green
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text('$i'),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: _currentPage < _totalPages
                                        ? () {
                                            setState(() {
                                              _currentPage++;
                                            });
                                          }
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      foregroundColor: Colors.black87,
                                    ),
                                    child: Text('Next'),
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
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        dense: true,
        onTap: onTap,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }
}
