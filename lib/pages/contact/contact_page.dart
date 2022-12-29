import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
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

  // States
  Contact _editedContact = Contact(name: '', email: '', phone: '');

  @override
  void initState() {
    super.initState();
    // Verifica se a página é de edição ou criação de um novo contato
    if (widget.contact != null) {
      // Clona o objeto Contact (transformando ele em Map e em seguida novamente em objeto).
      _editedContact = contactDaoImp.fromMap(contactDaoImp.toMap(widget.contact!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
