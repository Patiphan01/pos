import 'package:flutter/material.dart';
import '../leftzone/CreateMemberPopup.dart';

class MemberPopup extends StatefulWidget {
  final List<Map<String, String>> mockMembers;
  final Function(String) onSelectMember;

  const MemberPopup({
    Key? key,
    required this.mockMembers,
    required this.onSelectMember,
  }) : super(key: key);

  @override
  State<MemberPopup> createState() => _MemberPopupState();
}

class _MemberPopupState extends State<MemberPopup> {
  late List<Map<String, String>> filteredMembers;

  @override
  void initState() {
    super.initState();
    filteredMembers = widget.mockMembers;
  }

  void _filterMembers(String query) {
    setState(() {
      filteredMembers = widget.mockMembers
          .where((member) =>
              member['name']!.toLowerCase().contains(query.toLowerCase()) ||
              member['phone']!.contains(query))
          .toList();
    });
  }

  void _addNewMember(Map<String, String> newMember) {
    setState(() {
      widget.mockMembers.add(newMember);
      filteredMembers = widget.mockMembers; // Update the filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Select Member',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Box
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: _filterMembers,
                    decoration: InputDecoration(
                      hintText: 'Search member by name or telephone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateMemberPopup(
                        onAddMember: _addNewMember,
                      ),
                    );
                  },
                  mini: true,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Member List
            Expanded(
              child: ListView.builder(
                itemCount: filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = filteredMembers[index];
                  return GestureDetector(
                    onTap: () {
                      widget.onSelectMember(
                          '${member['name']} - ${member['phone']}');
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/img/Vector8.png',
                            width: 59,
                            height: 37,
                            color: const Color(0xFFFF6F6F),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                member['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            member['phone']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
