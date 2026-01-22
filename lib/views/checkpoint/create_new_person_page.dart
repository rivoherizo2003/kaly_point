import 'package:flutter/material.dart';
import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateNewPersonPage extends StatefulWidget {
  final int checkPointId;
  final int sessionId;
  const CreateNewPersonPage({super.key, required this.checkPointId, required this.sessionId});
  @override
  State<CreateNewPersonPage> createState() => _CreateNewPersonPageState();
}

class _CreateNewPersonPageState extends State<CreateNewPersonPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lastnameController;
  late TextEditingController _firstnameController;

  @override
  void initState() {
    super.initState();
    _lastnameController = TextEditingController();
    _firstnameController = TextEditingController();
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    super.dispose();
  }

  void _createNewPerson() {
    if (_formKey.currentState!.validate()) {
      context
          .read<PerformCheckPointViewModel>()
          .assignNewPersonToCheckPointAndSession(
            NewPersonDto(
              lastname: _lastnameController.text.trim(),
              firstname: _firstnameController.text.trim(),
              createdAt: DateTime.now(),
            ),
            widget.checkPointId,
            widget.sessionId
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une personne ajoutée avec succés")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 6,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 0.0,
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
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text("Ajouter une personne"),
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  hintText: 'Tapez le nom ici',
                  labelText: 'Nom',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir le nom';
                  }

                  if ((value.length < 3)) {
                    return 'Au moins 5 caractères';
                  }

                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  hintText: 'Tapez le prénom ici',
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              SizedBox(height: 8),
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
                      onPressed: _createNewPerson,
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
