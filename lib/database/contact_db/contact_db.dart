import 'package:my_contacts/database/contact_db/contact_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

// ********************************** //
// Classe de acesso ao banco de dados //
// ********************************** //

class ContactHelper {
  // Cria uma instância única deste propria classe.
  // Para que a mesma instância seja acessada de qualquer lugar (sem criar uma nova)
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  late Database _db; // <- - O acesso ao banco de dados será atribuido nesse atributo

  // Pegar o acesso ao banco de dados (se não for encontrado o mesmo será criado)
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  // Inicializa o banco de dados local
  Future<Database> initDb() async {
    // Recebe o caminho local em que será salvo o banco de dados
    final databasesPath = await getDatabasesPath();
    // Une o caminho do local para o banco de dados com o nome do arquivo que será o banco de dados
    final contactsDbPath = path.join(databasesPath, 'contacts.db');

    // Abrir o arquivo do banco de dados
    return await openDatabase(
      contactsDbPath, // <- - Caminho do arquivo
      version: 1, // <- - Versão do banco de dados
      onCreate: (Database db, int version) async {
        // <- - Função executada na primeira vez que o arquivo for aberto/criado
        // Comando SQL para criar a tabela
        await db.execute(ContactDao.sqlTable);
      },
    );
  }
}

// Função simples //// TODO: Remove this (just compare)
// Future<Database> getDatabase() async {
//   // Recebe o caminho local em que será salvo o banco de dados
//   final databasesPath = await getDatabasesPath();
//   // Une o caminho do local para o banco de dados com o nome do arquivo que será o banco de dados
//   final contactsDbPath = path.join(databasesPath, 'contacts.db');

//   return openDatabase(
//     contactsDbPath, // <- - Caminho do arquivo
//     version: 1, // <- - Versão do banco de dados
//     onCreate: (Database db, int version) async {
//       // <- - Função executada na primeira vez que o arquivo for aberto/criado
//       // Comando SQL para criar a tabela
//       await db.execute('CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT)');
//     },
//   );
// }
