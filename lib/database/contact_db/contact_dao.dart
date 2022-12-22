import 'package:my_contacts/database/contact_db/contact_db.dart';
import 'package:my_contacts/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

// ****************** //
// Classe de contrato //
// ****************** //

class ContactDao {
  // Nome da tabela usada no banco de dados
  static const String _tableName = 'contact_table';
  // Nomes das colunas
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _email = 'email';
  static const String _phone = 'phone';
  static const String _imageDirectory = 'image_directory';
  // Definição da tabela SQL
  static const String sqlTable = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_email TEXT, '
      '$_phone TEXT, '
      '$_imageDirectory TEXT)';

  // CRUD = Crete
  Future<int> saveContact(Contact contact) async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;
    // Inserir novo contato em uma tabela especifica do banco de dados
    /*
      OBS: O contato recebido vem com padrão o ID 0 (ou outro Number qualquer), porém ao ser inserido no banco de dados
      ele é substituido por um valor que não esteja em uso, e este novo ID é o que vem no retorno do método ".insert(...)"
    */
    final int newContactId = await contactDb.insert(_tableName, _toMap(contact));

    return newContactId;
  }

  // CRUD = Read (Pegar contato por ID)
  Future<Contact?> getContact(int contactId) async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;

    // Criar uma "query" para pesquisar no banco de dados e retornar o mesmo
    List<Map<String, dynamic>> contactMap = await contactDb.query(
      _tableName, // <- - - Nome da tabela
      columns: [_id, _name, _email, _phone, _imageDirectory], // <- - - Colunas que devem ser retornadas
      where: '$_id = ?', // <- - - Coluna em que se deve fazer a pesquisa
      whereArgs: [contactId], // <- - - Argumento usado para a pesquisa
    );

    // Verificar se algum valor foi encontrado
    if (contactMap.isNotEmpty) {
      return _fromMap(contactMap.first);
    } else {
      return null;
    }
  }

  // CRUD = Read (Pegar todos os contatos)
  Future<List<Contact>> getAllContact() async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;

    // Criar uma "query" para pesquisar no banco de dados e retornar todos os dados encontrados
    List<Map<String, dynamic>> contactsMap = await contactDb.rawQuery(
      'SELECT * FROM $_tableName', // <- - - Seleciona todos os elementos da tabela
    );

    List<Contact> contactsObj = [];

    for (Map<String, dynamic> contact in contactsMap) {
      contactsObj.add(_fromMap(contact));
    }

    return contactsObj;
  }

  // CRUD = Delete (Apagar contato por ID)
  Future<int> deleteContact(int contactId) async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;

    // Criar uma "query" para pesquisar no banco de dados e remover o mesmo
    final int deletedContactId = await contactDb.delete(
      _tableName, // <- - - Nome da tabela
      where: '$_id = ?', // <- - - Coluna em que se deve fazer a pesquisa
      whereArgs: [contactId], // <- - - Argumento usado para a pesquisa
    );

    return deletedContactId;
  }

  // CRUD = Update (Atualizar contato por ID)
  Future<int> updateContact(Contact contactObj) async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;

    // Criar uma "query" para pesquisar no banco de dados e remover o mesmo
    final int updatedContactId = await contactDb.update(
      _tableName, // <- - - Nome da tabela
      _toMap(contactObj), // <- - - JSON do objeto que será alterado no banco de dados
      where: '$_id = ?', // <- - - Coluna em que se deve fazer a pesquisa
      whereArgs: [contactObj.id], // <- - - Argumento usado para a pesquisa
    );

    return updatedContactId;
  }

  // CRUD = Read (Pegar quantidade total de contatos)
  Future<int?> getContactQuantity() async {
    // Pegar o acesso ao banco de dados
    Database contactDb = await ContactHelper().db;

    // Criar uma "query" para pesquisar no banco de dados e retornar todos os dados encontrados
    List<Map<String, dynamic>> contactsMap = await contactDb.rawQuery(
      'SELECT COUNT(*) FROM $_tableName', // <- - - Faz contagem de todos os elementos da tabela
    );

    return Sqflite.firstIntValue(contactsMap);
  }

  // Fechar banco de dados
  Future closeDb() async {
    Database contactDb = await ContactHelper().db;
    contactDb.close();
  }

  // Criar objeto Contact a partir do JSON
  Contact _fromMap(Map<String, dynamic> contactMap) {
    final Contact contactObj = Contact(
      id: contactMap[_id],
      name: contactMap[_name],
      email: contactMap[_email],
      phone: contactMap[_phone],
      imageDirectory: contactMap[_imageDirectory],
    );

    return contactObj;
  }

  // Criar JSON a partir do objeto Contact
  Map<String, dynamic> _toMap(Contact contactObj) {
    Map<String, dynamic> contactMap = {
      _id: contactObj.id,
      _name: contactObj.name,
      _email: contactObj.email,
      _phone: contactObj.phone,
      _imageDirectory: contactObj.imageDirectory,
    };

    return contactMap;
  }
}
