import 'package:my_contacts/models/contact.dart';

// ******************************* //
// Classe abstrata DAO do contrato //
// ******************************* //

abstract class ContactDao {
  // CRUD = Crete
  Future<int> saveContact(Contact contact);

  // CRUD = Read (Pegar contato por ID)
  Future<Contact?> getContact(int contactId);

  // CRUD = Read (Pegar todos os contatos)
  Future<List<Contact>> getAllContact();

  // CRUD = Delete (Apagar contato por ID)
  Future<int> deleteContact(int contactId);

  // CRUD = Update (Atualizar contato por ID)
  Future<int> updateContact(Contact contactObj);

  // CRUD = Read (Pegar quantidade total de contatos)
  Future<int?> getContactQuantity();

  // Fechar banco de dados
  Future closeDb();

  // Criar objeto Contact a partir do JSON
  Contact _fromMap(Map<String, dynamic> contactMap);

  // Criar JSON a partir do objeto Contact
  Map<String, dynamic> _toMap(Contact contactObj);
}
