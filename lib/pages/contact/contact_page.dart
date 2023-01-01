import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  // Props
  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // Instances
  ContactDaoImp contactDaoImp = ContactDaoImp();

  // Input controls
  final TextEditingController inputNameController = TextEditingController();
  final TextEditingController inputEmailController = TextEditingController();
  final TextEditingController inputPhoneController = TextEditingController();
  // States
  Contact _editedContact = Contact(name: '', email: '', phone: '');
  bool _isEditedContact = false;
  final FocusNode inputNameFocusNode = FocusNode();
  final FocusNode inputEmailFocusNode = FocusNode();
  final FocusNode inputPhoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Verifica se a página é de edição ou criação de um novo contato
    if (widget.contact != null) {
      _isEditedContact = true;

      // Clona o objeto Contact (transformando ele em Map e em seguida novamente em objeto).
      _editedContact = contactDaoImp.fromMap(contactDaoImp.toMap(widget.contact!));

      // Aplica os valores iniciais dos inputs
      inputNameController.text = _editedContact.name;
      inputEmailController.text = _editedContact.email;
      inputPhoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditedContact ? 'Edit contact' : 'Create contact'),
          centerTitle: true,
          backgroundColor: darkLightColor,
        ),
        backgroundColor: darkColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Verifica se os campos estão preenchidos
            if (_editedContact.name.isNotEmpty) {
              if (_editedContact.email.isNotEmpty || _editedContact.phone.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(inputPhoneFocusNode);
              }
            } else {
              // Foca no input "Name"
              FocusScope.of(context).requestFocus(inputNameFocusNode);
            }
          },
          backgroundColor: mainColor,
          child: const Icon(
            Icons.save,
            color: darkColor,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  // Seleciona uma imagem da galeria (para pegar da câmera substitua ".gallery" por ".camera")
                  ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
                    // Verifica se uma imagem foi selecionada
                    if (value == null) return;
                    setState(() {
                      _editedContact.imageDirectory = value.path;
                    });
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.imageDirectory != null
                          ? FileImage(File(_editedContact.imageDirectory!))
                          : const AssetImage('images/person.png') as ImageProvider,
                    ),
                  ),
                ),
              ),
              const Divider(),
              buildTextField('Name', TextInputType.name, inputNameController, (String inputValue) {
                setState(() {
                  _editedContact.name = inputValue;
                });
              }, inputNameFocusNode),
              const Divider(),
              buildTextField('E-Mail', TextInputType.emailAddress, inputEmailController, (String inputValue) {
                setState(() {
                  _editedContact.email = inputValue;
                });
              }, inputEmailFocusNode),
              const Divider(),
              buildTextField('Phone number', TextInputType.phone, inputPhoneController, (String inputValue) {
                setState(() {
                  _editedContact.phone = inputValue;
                });
              }, inputPhoneFocusNode),
            ],
          ),
        ),
      ),
    );
  }

  // Uma função que intercepta a ação de "page pop"
  Future<bool> _requestPop() async {
    if (_isEditedContact) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkLightColor,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            title: const Text('Discard changes?'),
            content: const Text('If you exit the changes will be lost.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Primeiro pop fecha o Alert e o segundo fecha a página de contatos
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
      // Impede a ação de pop inicial (para ser feito de forma manual)
      return Future.value(false);
    } else {
      // Mantém a ação de pop inicial
      return Future.value(true);
    }
  }

  // Cria diferentes inputs de textos
  Widget buildTextField(
      String labelText, TextInputType keyboardType, TextEditingController inputController, Function onChange, FocusNode inputFocusNode) {
    return TextField(
      controller: inputController,
      focusNode: inputFocusNode,
      onChanged: (value) {
        onChange(value);
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
