import 'package:flutter/material.dart';
import 'package:kaly_point/models/edit_session.dart';
import 'package:kaly_point/viewmodels/sessions/session_viewmodel.dart';
import 'package:provider/provider.dart';

class EditSessionPage extends StatefulWidget {
  final int sessionId;

  const EditSessionPage({super.key, required this.sessionId});

  @override
  State<EditSessionPage> createState() => _EditSessionPageState();
}

class _EditSessionPageState extends State<EditSessionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late EditSession? editSession;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _loadSessionData();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadSessionData() async {
    final sessionViewModel = context.read<SessionViewModel>();
    try {
      final sessionToEdit = sessionViewModel.sessions.firstWhere((element) => element.id == widget.sessionId);
      setState(() {
        _titleController.text = sessionToEdit.title;
        _descriptionController.text = sessionToEdit.description!;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      context.read<SessionViewModel>().saveSession(
        EditSession(
          id: widget.sessionId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
      context.read<SessionViewModel>().fetchSessions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session saved with success")),
      );
      // close modal
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 10.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Session title',
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a session title';
                  }

                  if ((value.length < 3)) {
                    return 'Title must be at least 5 characters';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Session description',
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        foregroundColor: Colors.orange,
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveSession(),
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        foregroundColor: Colors.green,
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
