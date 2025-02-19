import 'package:flutter/material.dart';

class CreateMemberPopup extends StatefulWidget {
  final Function(Map<String, String>) onAddMember;

  const CreateMemberPopup({Key? key, required this.onAddMember})
      : super(key: key);

  @override
  State<CreateMemberPopup> createState() => _CreateMemberPopupState();
}

class _CreateMemberPopupState extends State<CreateMemberPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void _onConfirm() {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      widget.onAddMember({
        'name': nameController.text,
        'phone': phoneController.text,
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and phone number are required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white, // Set the background color to white
      child: SingleChildScrollView(
        // Allows scrolling if the content overflows
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Create New Member',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ],
              ),
              // Form Layout with logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo Section
                        Container(
                          width: 120, // Adjust the width for proper proportions
                          height:
                              150, // Adjust the height for proper proportions
                          margin: const EdgeInsets.only(right: 20),
                          child: Image.asset(
                            'assets/img/customer.png', // Path to customer logo
                            fit: BoxFit
                                .contain, // Maintain proportions of the logo
                          ),
                        ),
                        // Input Fields Section
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Phone Number',
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: dobController,
                                readOnly: true, // Prevent manual editing
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      dobController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"; // Format the date
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Date of Birth',
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email Address',
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: noteController,
                                decoration: const InputDecoration(
                                  hintText: 'Note',
                                  prefixIcon:
                                      Icon(Icons.note, color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Button
              GestureDetector(
                onTap: _onConfirm,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
