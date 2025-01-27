import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final username = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      // Requête vers la table "compte" pour vérifier les identifiants
      final response = await Supabase.instance.client
          .from('compte')
          .select('password, role')
          .eq('username', username)
          .maybeSingle();

      if (response == null) {
        // Aucun utilisateur trouvé
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur introuvable')),
        );
      } else {
        // Vérifiez si le mot de passe correspond
        if (response['password'] == password) {
          final role = response['role']; // Récupérez le rôle de l'utilisateur

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connexion réussie en tant que $role')),
          );

          // Redirigez l'utilisateur vers AccueilPage
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mot de passe incorrect')),
          );
        }
      }
    } catch (e) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ de saisie pour le nom d'utilisateur
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Champ de saisie pour le mot de passe
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            // Bouton de connexion
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
