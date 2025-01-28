import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      // Vérifiez si l'utilisateur existe déjà
      final existingUser = await Supabase.instance.client
          .from('compte')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le nom d\'utilisateur existe déjà')),
        );
        return;
      }

      // Insérez le nouvel utilisateur
      await Supabase.instance.client.from('compte').insert({
        'username': username,
        'password': password,
        'role': 'user', // Rôle par défaut
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie.')),
      );

      // Redirigez vers la page de connexion
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S\'inscrire')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _signup(context),
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
