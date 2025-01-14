import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:paychain_mobile/data/models/wallet.dart';
import 'package:paychain_mobile/modules/transfer/dtos/transaction_request.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'WalletDB.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> dropDb() async {
    // Lấy đường dẫn cơ sở dữ liệu
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'WalletDB.db');

    // Kiểm tra xem tệp có tồn tại không, sau đó xóa nó
    if (await File(path).exists()) {
      await File(path).delete();
      print("Database deleted: $path");
    } else {
      print("No database found to delete.");
    }

    // Đặt lại đối tượng database trong ứng dụng
    _database = null;
  }

  Future _onCreate(Database db, int version) async {
    print('initializing...');
    // Tạo bảng User
    await db.execute('''
    CREATE TABLE users (
      _id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      contactList TEXT,
      walletList TEXT,
      isVerified INTEGER NOT NULL
    )
  ''');

    // Thêm dữ liệu người dùng mặc định
    await db.insert('users', {
      '_id': '6785d4767e21292cd4793ec1',
      'name': 'Demo Account 1',
      'email': 'demoaccount1@gmail.com',
      'password':
          r'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
      'contactList': '["0206669"]',
      'walletList': '["6785d4767e21292cd4793ec2"]',
      'isVerified': 1
    });

    await db.insert('users', {
      '_id': '6785d5ae7e21292cd4793ec3',
      'name': 'Demo Account 2',
      'email': 'demoaccount2@gmail.com',
      'password':
          r'$2a$10$SYsS2OufFtgzz18l1Vu7buvrHZxXeumccC2KSdRofx2nFu7Pz33Cq',
      'contactList': '["2540837"]',
      'walletList': '["6785d5ae7e21292cd4793ec4"]',
      'isVerified': 1
    });

    await db.execute('''
    CREATE TABLE wallets (
      _id TEXT PRIMARY KEY,
      privateKeyBase64 TEXT NOT NULL,
      publicKeyBase64 TEXT NOT NULL,
      account TEXT NOT NULL,
      email TEXT NOT NULL,
      balance REAL NOT NULL,
      nameNode TEXT NOT NULL,
      node TEXT NOT NULL,
      "transaction" TEXT
    )''');

    // Wallet 1
    await db.insert('wallets', {
      '_id': '6785d4767e21292cd4793ec2',
      'privateKeyBase64':
          'MIGNAgEAMBAGByqGSM49AgEGBSuBBAAKBHYwdAIBAQQgFtqdtG7yS6BKOFxfGTKPtjPPzS9hRbywV/ipaUsOtjugBwYFK4EEAAqhRANCAATHHzJPJmeFCxTtwHbhuX+EaNYlFtPIgYY7duzRHMkj9LYO89RMCXyxLBr53KLAkElQHkCSk9utVZSr3amm2BMp',
      'publicKeyBase64':
          'MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAExx8yTyZnhQsU7cB24bl/hGjWJRbTyIGGO3bs0RzJI/S2DvPUTAl8sSwa+dyiwJBJUB5AkpPbrVWUq92pptgTKQ==',
      'account': '2540837',
      'email': 'demoaccount1@gmail.com',
      'balance': 100.0,
      'nameNode': '3RG',
      'node': '677b7433c9249c71040b11ab',
      'transaction': '''
    [
      {
        "txHash": "0000fc903497b671644d9aa2b573a5d6ab34bbaf3d5564800d9585e63d14d228",
        "previousHash": "00008be500d9136f06e8554427026f90873115a674bf000acc5afd8555a55ebc",
        "nonce": 4197,
        "data": "Block chứa giao dịch",
        "accountSender": "0206669",
        "accountReceiver": "2540837",
        "amount": 10.0,
        "fee": 0.1,
        "message": "Demo Account 1 chuyển tiền",
        "nameSender": "Demo Account 2",
        "nameReceiver": "Demo Account 1",
        "timestamp": 1736824321097,
        "typeTransaction": "RECEIVER"
      },
      {
        "txHash": "000018bdbeec45a3729695b9152a4b4e231fc417f6360ea8f453a03bc238ea69",
        "previousHash": "0000fc903497b671644d9aa2b573a5d6ab34bbaf3d5564800d9585e63d14d228",
        "nonce": 83593,
        "data": "Block chứa giao dịch",
        "accountSender": "2540837",
        "accountReceiver": "0206669",
        "amount": 10.0,
        "fee": 0.1,
        "message": "Demo Account 1 chuyển tiền",
        "nameSender": "Demo Account 1",
        "nameReceiver": "Demo Account 2",
        "timestamp": 1736824472232,
        "typeTransaction": "SENDER"
      }
    ]
  '''
    });

// Wallet 2
    await db.insert('wallets', {
      '_id': '6785d5ae7e21292cd4793ec4',
      'privateKeyBase64':
          'MIGNAgEAMBAGByqGSM49AgEGBSuBBAAKBHYwdAIBAQQgFx0F4OJqnZxi40CL8mjJpqv1DnXaPopsfJcX3Uln1ZagBwYFK4EEAAqhRANCAAQQyQEg0npQlcF3Nf/b8NYKa0W7uuJh+LRjRZkhgMe87pQNvN7UM5JdtHA2+KikmRO1XBMySxG1D1kiZY1o7smS',
      'publicKeyBase64':
          'MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEEMkBINJ6UJXBdzX/2/DWCmtFu7riYfi0Y0WZIYDHvO6UDbze1DOSXbRwNviopJkTtVwTMksRtQ9ZImWNaO7Jkg==',
      'account': '0206669',
      'email': 'demoaccount2@gmail.com',
      'balance': 100.0,
      'nameNode': '3RG',
      'node': '677b7433c9249c71040b11ab',
      'transaction': '''
    [
      {
        "txHash": "0000fc903497b671644d9aa2b573a5d6ab34bbaf3d5564800d9585e63d14d228",
        "previousHash": "00008be500d9136f06e8554427026f90873115a674bf000acc5afd8555a55ebc",
        "nonce": 4197,
        "data": "Block chứa giao dịch",
        "accountSender": "0206669",
        "accountReceiver": "2540837",
        "amount": 10.0,
        "fee": 0.1,
        "message": "Demo Account 1 chuyển tiền",
        "nameSender": "Demo Account 2",
        "nameReceiver": "Demo Account 1",
        "timestamp": 1736824321097,
        "typeTransaction": "SENDER"
      },
      {
        "txHash": "000018bdbeec45a3729695b9152a4b4e231fc417f6360ea8f453a03bc238ea69",
        "previousHash": "0000fc903497b671644d9aa2b573a5d6ab34bbaf3d5564800d9585e63d14d228",
        "nonce": 83593,
        "data": "Block chứa giao dịch",
        "accountSender": "2540837",
        "accountReceiver": "0206669",
        "amount": 10.0,
        "fee": 0.1,
        "message": "Demo Account 1 chuyển tiền",
        "nameSender": "Demo Account 1",
        "nameReceiver": "Demo Account 2",
        "timestamp": 1736824472232,
        "typeTransaction": "RECEIVER"
      }
    ]
  '''
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getWallets() async {
    final db = await database;
    return await db.query('wallets');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getWalletsByEmail(String email) async {
    final db = await database;

    // Truy vấn User để lấy userId dựa trên email
    final userResult = await db.query(
      'users',
      columns: ['email'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (userResult.isEmpty) {
      // Nếu không tìm thấy User, trả về danh sách rỗng
      return [];
    }

    // // Lấy userId từ kết quả truy vấn
    // final userId = userResult.first['id'];

    // Truy vấn bảng Wallet để lấy danh sách wallet theo userId
    final walletResult = await db.query(
      'wallets',
      where: 'email = ?',
      whereArgs: [email],
    );

    return walletResult;
  }

  Future<List<Map<String, dynamic>>> getContactListByEmail(String email) async {
    // 1. Truy vấn bảng users để lấy contactList
    final db = await database;
    final userResult = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (userResult.isEmpty) {
      throw Exception("Người dùng không tồn tại.");
    }

    final user = userResult.first;

    // 2. Lấy contactList từ user
    final String contactListString = user['contactList'] as String;
    if (contactListString.isEmpty) {
      return [];
    }

    // 3. Parse contactList từ JSON
    List<String> contactAccounts;
    try {
      contactAccounts = List<String>.from(jsonDecode(contactListString));
    } catch (e) {
      throw Exception("Dữ liệu contactList không hợp lệ: $contactListString");
    }

    List<Map<String, dynamic>> contacts = [];
    // 4. Truy vấn bảng wallets để lấy thông tin account và name
    for (String account in contactAccounts) {
      final wallet = await db.query(
        'wallets',
        where: 'account = ?',
        whereArgs: contactAccounts,
      );
      final user = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [Wallet.fromJson(wallet.first).email ?? ''],
      );

      final result = {'name': user.first['name'], 'account': account};
      contacts.add(result);
    }

    return contacts;
  }

  Future<Map<String, dynamic>> getUserByAccount(String account) async {
    // 1. Truy vấn bảng users để lấy contactList
    final db = await database;

    final wallet = await db.query('wallets',
        where: 'account = ?', whereArgs: [account], limit: 1);

    final userResult = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [Wallet.fromJson(wallet.first).email],
      limit: 1,
    );
    return userResult.first;
  }

  addTransactionToWallet(TransactionRequest request) async {
    print(request);
    final db = await database;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Hàm phụ: Lấy danh sách giao dịch và thêm giao dịch mới
    Future<void> _addTransaction(
        String account, Map<String, dynamic> transaction) async {
      final wallet = await db.query(
        'wallets',
        where: 'account = ?',
        whereArgs: [account],
        limit: 1,
      );

      if (wallet.isEmpty) {
        throw Exception("Wallet không tồn tại cho account: $account");
      }

      // Lấy danh sách transaction
      final walletData = wallet.first;
      List<dynamic> transactions = [];
      final transactionString = walletData['transaction'].toString();

      if (transactionString.isNotEmpty) {
        try {
          transactions = jsonDecode(transactionString);
        } catch (e) {
          throw Exception(
              "Dữ liệu transaction không hợp lệ: $transactionString");
        }
      }

      // Thêm giao dịch mới
      transactions.add(transaction);

      final currentBalance = walletData['balance'] as double;
      // Cập nhật lại dữ liệu
      switch (transaction['typeTransaction']) {
        case 'SENDER':
          await db.update(
            'wallets',
            {
              'transaction': jsonEncode(transactions),
              'balance': currentBalance -
                  transaction['amount'] -
                  transaction['fee'] * transaction['amount']
            },
            where: 'account = ?',
            whereArgs: [account],
          );
        case 'RECEIVER':
          await db.update(
            'wallets',
            {
              'transaction': jsonEncode(transactions),
              'balance': currentBalance + transaction['amount']
            },
            where: 'account = ?',
            whereArgs: [account],
          );
          break;
        default:
      }
    }

    // Tạo giao dịch cho người gửi
    final senderTransaction = {
      'txHash': '',
      'previousHash': '',
      'nonce': 0,
      'data': '',
      'accountSender': request.accountSender,
      'accountReceiver': request.accountReceiver,
      'amount': request.amount,
      'fee': 0.1,
      'message': request.note,
      'nameSender': request.senderName,
      'nameReceiver': request.receiverName,
      'timestamp': timestamp,
      'typeTransaction': 'SENDER'
    };

    // Tạo giao dịch cho người nhận
    final receiverTransaction = {
      'txHash': '',
      'previousHash': '',
      'nonce': 0,
      'data': '',
      'accountSender': request.accountSender,
      'accountReceiver': request.accountReceiver,
      'amount': request.amount,
      'fee': 0.1,
      'message': request.note,
      'nameSender': request.senderName,
      'nameReceiver': request.receiverName,
      'timestamp': timestamp,
      'typeTransaction': 'RECEIVER'
    };

    // Thực hiện cập nhật cho cả người gửi và người nhận
    await _addTransaction(request.accountSender!, senderTransaction);
    await _addTransaction(request.accountReceiver!, receiverTransaction);
    return senderTransaction;
  }
}
