import 'package:flutter/material.dart';
import 'package:kaly_point/dto/edit_session_dto.dart';
import 'package:kaly_point/viewmodels/session_viewmodel.dart';
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
  late EditSessionDto? editSession;

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
        _descriptionController.text = sessionToEdit.description ?? "vide";
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      context.read<SessionViewModel>().saveSession(
        EditSessionDto(
          id: widget.sessionId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
      context.read<SessionViewModel>().fetchSessions();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session sauvegardée")),
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
                  hintText: 'Titre',
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir le titre';
                  }

                  if ((value.length < 3)) {
                    return 'Au moins 5 caractères';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
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
                      child: const Text("Annuler"),
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
                      child: const Text("Enregistrer"),
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
