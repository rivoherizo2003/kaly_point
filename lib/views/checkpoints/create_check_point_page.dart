import 'package:flutter/material.dart';
import 'package:kaly_point/models/new_check_point.dart';
import 'package:kaly_point/viewmodels/checkpoint_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateCheckPointPage extends StatefulWidget {
  final int sessionId;
  final String title;
  
  const CreateCheckPointPage({ super.key, required this.sessionId, required this.title});

  @override
  State<CreateCheckPointPage> createState() => _CreateCheckPointPageState();
}

class _CreateCheckPointPageState extends State<CreateCheckPointPage> {
final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createNewCheckPoint() {
    if (_formKey.currentState!.validate()) {
      context.read<CheckpointViewmodel>().createCheckPoint(
        NewCheckPoint(
          title: _titleController.text.trim(),
          createdAt: DateTime.now(),
          description: _descriptionController.text.trim(),
          sessionId: widget.sessionId
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pointage ajoutée avec succés")),
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
                      onPressed: _createNewCheckPoint,
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        foregroundColor: Colors.green,
                      ),
                      child: const Text("Créer"),
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