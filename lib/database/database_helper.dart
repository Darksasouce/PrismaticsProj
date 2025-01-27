import 'package:postgres/postgres.dart';

void main() async {
  final connection = PostgreSQLConnection(
    'db.gcnbamsqhqgxqulmyrho.supabase.co', // Supabase host
    5432,                                  // Port
    'postgres',                            // Database name
    username: 'postgres',                  // Default username
    password: 'prismatics12345',           // Supabase password
    useSSL: true,                          // Enable SSL for secure connections
  );

  try {
    await connection.open();
    print('Connected to Supabase PostgreSQL database successfully.');

    // Perform a query (example)
    var results = await connection.query('SELECT * FROM your_table'); // Replace 'your_table' with your actual table name
    for (final row in results) {
      print(row.toString());
    }
  } catch (e) {
    print('Error connecting to the database: $e');
  } finally {
    await connection.close();
    print('Database connection closed.');
  }
}
