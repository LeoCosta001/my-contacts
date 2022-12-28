import 'package:flutter/material.dart';
import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';
import 'package:my_contacts/widgets/contact_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactDaoImp contactDaoImpl = ContactDaoImp();

  // Requests local DB
  void contactListReload() {
    contactDaoImpl.getAllContact().then((value) {
      setState(() {
        contactList = value;
      });
    });
  }

  // States
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    contactListReload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My contacts'),
        centerTitle: true,
        backgroundColor: darkLightColor,
      ),
      backgroundColor: darkColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add,
          color: darkColor,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          late Contact currentContact = contactList[index];
          return ContactCard(contact: currentContact);
        },
      ),
    );
  }
}
