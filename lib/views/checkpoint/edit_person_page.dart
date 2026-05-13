import 'package:flutter/material.dart';
import 'package:kaly_point/dto/edit_person_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:provider/provider.dart';

class EditPersonPage extends StatefulWidget {
  final PersonCheckPointDto personCheckPointDto;
  final int indexActiveTab;

  const EditPersonPage({
    super.key,
    required this.personCheckPointDto, required this.indexActiveTab,
  });
  @override
  State<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lastnameController;
  late TextEditingController _firstnameController;

  @override
  void initState() {
    super.initState();
    _lastnameController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController.text = widget.personCheckPointDto.lastname;
    _firstnameController.text = widget.personCheckPointDto.firstname ?? "";
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    super.dispose();
  }

  void _savePerson() {
    if (_formKey.currentState!.validate()) {
      context
          .read<PerformCheckPointViewModel>()
          .savePerson(editPersonDto: 
            EditPersonDto(
              id: widget.personCheckPointDto.personId,
              lastname: _lastnameController.text.trim(),
              firstname: _firstnameController.text.trim(),
            ),
            indexTabActive: widget.indexActiveTab
          );
          
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une personne modifié avec succés")),
      );
      if (context.read<PerformCheckPointViewModel>().errorMessage == null) {
        Navigator.pop(context);
      }
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
                child: Text("Modifier une personne"),
              ),
              if (context.read<PerformCheckPointViewModel>().errorMessage !=
                  null)
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    context.read<PerformCheckPointViewModel>().errorMessage ??
                        "",
                        style: TextStyle(color: Colors.red),
                  ),
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
                      onPressed: _savePerson,
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
