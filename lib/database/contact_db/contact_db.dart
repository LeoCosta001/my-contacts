import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

// ********************************** //
// Classe de acesso ao banco de dados //
// ********************************** //

class ContactConnection {
  // Implementações estáticas para que todas as instâcias
  // tenham acesso ao mesmo atributos e métodos

  static Database? _db; // <- - O acesso ao banco de dados será atribuido nesse atributo

  // Retorna o banco de dados local
  // E inicializa o mesmo caso não exista ainda
  static Future<Database?> db() async {
    if (_db == null) {
      // Recebe o caminho local em que será salvo o banco de dados
      final databasesPath = await getDatabasesPath();
      // Une o caminho do local para o banco de dados com o nome do arquivo que será o banco de dados
      final contactsDbPath = path.join(databasesPath, 'contacts.db');

      // Abrir o arquivo do banco de dados
      _db = await openDatabase(
        contactsDbPath, // <- - Caminho do arquivo
        version: 1, // <- - Versão do banco de dados
        onCreate: (Database db, int version) async {
          // <- - Função executada na primeira vez que o arquivo for aberto/criado
          // Comando SQL para criar a tabela
          await db.execute(ContactDaoImp.sqlTable);
        },
      );
    }

    return _db;
  }
}
