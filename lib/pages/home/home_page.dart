import 'package:flutter/material.dart';
import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';
import 'package:my_contacts/pages/contact/contact_page.dart';
import 'package:my_contacts/widgets/contact_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum OrderOptions { orderAz, orderZa }

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
        actions: [
          // Popup menu para selecionar o tipo de ordenação da lista
          PopupMenuButton<OrderOptions>(
            color: darkLightColor,
            itemBuilder: ((context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    value: OrderOptions.orderAz,
                    child: Text('Sort A to Z'),
                  ),
                  const PopupMenuItem<OrderOptions>(
                    value: OrderOptions.orderZa,
                    child: Text('Sort Z to A'),
                  ),
                ]),
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: darkColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToContactPage(null);
        },
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
          return ContactCard(
              contact: currentContact,
              onTap: () {
                _showOptions(context, currentContact);
              });
        },
      ),
    );
  }

  // Função para reordenar a lista
  void _orderList(OrderOptions value) {
    switch (value) {
      case OrderOptions.orderAz:
        contactList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZa:
        contactList.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }

    // Setstate vazio apenas para recarregar os widgets com as novas alterações.
    setState(() {});
  }

  void _showOptions(BuildContext context, Contact contact) {
    // Exibe um modal de botões
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          backgroundColor: darkLightColor,
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (contact.phone.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          // Abre o aplicativo nativo de ligação do dispositivo (com o número de telefone atribuido em "path")
                          launchUrl(Uri(scheme: 'tel', path: contact.phone));
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Call',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _goToContactPage(contact);
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await contactDaoImpl.deleteContact(contact.id!);
                        contactListReload();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _goToContactPage(Contact? contact) async {
    // Abre a página de "Contatos" podendo ou não receber um outro contato (editado ou criado) como retorno
    final Contact? reqContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );

    // Verifica se obteve um contato como retorno da página de "Contatos"
    if (reqContact != null) {
      // Verifica se o contato recebido deve ser atualizado ou criado
      if (contact != null) {
        await contactDaoImpl.updateContact(reqContact);
      } else {
        await contactDaoImpl.saveContact(reqContact);
      }

      contactListReload();
    }
  }
}
