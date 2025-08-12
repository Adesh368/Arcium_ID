// lib/widgets/id_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/member_provider.dart';
import '../models/member.dart';
import '../theme/arcium_theme.dart';

/// IDForm renders input fields for the member to type their information.
/// It uses Riverpod to update the shared Member state.
class IDForm extends ConsumerStatefulWidget {
   final GlobalKey<FormState> formKey; // Add this line

  const IDForm({Key? key, required this.formKey}) : super(key: key); // Add required parameter

  @override
  ConsumerState<IDForm> createState() => _IDFormState();
}

class _IDFormState extends ConsumerState<IDForm> {
  
  // controllers for text fields so we can prefill and read easily
  late TextEditingController _nameController;
  late TextEditingController _discordController;
  late TextEditingController _roleController;
  late TextEditingController _countryController;

  // track selected date in state
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // initialize controllers with provider values (if any)
    final member = ref.read(memberProvider);
    _nameController = TextEditingController(text: member.name);
    _discordController = TextEditingController(text: member.discordUsername);
    _roleController = TextEditingController(text: member.discordRole);
    _countryController = TextEditingController(text: member.country);
    _selectedDate = member.dateJoined;
  }

  @override
  void dispose() {
    // dispose controllers to avoid leaks
    _nameController.dispose();
    _discordController.dispose();
    _roleController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // show date picker and update provider
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2008), // arbitrary lower bound
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      ref.read(memberProvider.notifier).updateDateJoined(picked);
    }
  }

  // apply field value changes into the provider
  void _applyToProvider() {
    // update provider with every controller's text
    ref.read(memberProvider.notifier).updateName(_nameController.text.trim());
    ref
        .read(memberProvider.notifier)
        .updateDiscordUsername(_discordController.text.trim());
    ref.read(memberProvider.notifier).updateDiscordRole(_roleController.text.trim());
    ref.read(memberProvider.notifier).updateCountry(_countryController.text.trim());

    if (_selectedDate != null) {
      ref.read(memberProvider.notifier).updateDateJoined(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // consumer watches member state to reflect any external changes
    final member = ref.watch(memberProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: widget.formKey,
          onChanged: _applyToProvider, // whenever form changes, update provider
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create your Arcium community ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) return 'Please add a name';
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Date joined (picker)
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date joined',
                      hintText: _selectedDate != null
                          ? DateFormat.yMMMd().format(_selectedDate!)
                          : 'Select date',
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (v) {
                      if (_selectedDate == null) return 'Please choose join date';
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Discord username
              TextFormField(
                controller: _discordController,
                decoration: const InputDecoration(labelText: 'Discord username'),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please add your Discord username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Discord role
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Discord role'),
              ),
              const SizedBox(height: 10),

              // Country
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
              ),

              const SizedBox(height: 16),

              // small hint and reset button row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'You can download and share your ID to X after entering details.\nGreeting: gMPC',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      // reset both provider and controllers
                      ref.read(memberProvider.notifier).reset();
                      _nameController.clear();
                      _discordController.clear();
                      _roleController.clear();
                      _countryController.clear();
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                    child: const Text('Reset'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
