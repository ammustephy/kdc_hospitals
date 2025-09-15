
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Profile_Provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      mobileController,
      emailController,
      dobController;
  String? selectedGender;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    nameController = TextEditingController(text: provider.name);
    mobileController = TextEditingController(text: provider.mobile);
    emailController = TextEditingController(text: provider.email);
    dobController = TextEditingController(text: provider.dob);
    selectedGender = provider.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _toggleEdit,
            child: Text(
              _isEditing ? 'Save' : 'Edit',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 16,
                          child: Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                hint: "Full Name",
                controller: nameController,
                onChanged: provider.updateName,
                enabled: _isEditing,
                validator: (val) => val == null || val.isEmpty ? 'Enter full name' : null,
              ),
              _buildTextField(
                hint: "Mobile number",
                controller: mobileController,
                keyboardType: TextInputType.phone,
                onChanged: provider.updateMobile,
                enabled: _isEditing,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter mobile number';
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(val)) return 'Enter valid 10-digit mobile';
                  return null;
                },
              ),
              _buildTextField(
                hint: "Email id",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: provider.updateEmail,
                enabled: _isEditing,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(val)) return 'Enter valid email';
                  return null;
                },
              ),
              _buildDateField(provider),
              _buildGenderDropdown(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDateField(ProfileProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: _isEditing,
        controller: dobController,
        readOnly: true,
        validator: (val) => val == null || val.isEmpty ? 'Select date of birth' : null,
        onTap: _isEditing
            ? () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(provider.dob) ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            final formatted = "${picked.day}/${picked.month}/${picked.year}";
            dobController.text = formatted;
            provider.updateDob(formatted);
          }
        }
            : null,
        decoration: InputDecoration(
          hintText: "Date of Birth",
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(ProfileProvider provider) {
    const options = ['Male', 'Female', 'Other'];
    final currentValue = options.contains(selectedGender) ? selectedGender : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: options.map((gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: _isEditing
            ? (val) {
          if (val != null) {
            setState(() => selectedGender = val);
            provider.updateGender(val);
          }
        }
            : null,
        validator: (val) => val == null || val.isEmpty ? 'Select gender' : null,
        decoration: InputDecoration(
          hintText: "-- Gender --",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  void _toggleEdit() {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    if (_isEditing) {
      // Save
      if (_formKey.currentState?.validate() ?? false) {
        provider.saveProfile();
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      }
    } else {
      setState(() => _isEditing = true);
    }
  }
}
