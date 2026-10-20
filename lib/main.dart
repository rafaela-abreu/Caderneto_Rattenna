import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CadernetoApp());
}

class CadernetoApp extends StatelessWidget {
  const CadernetoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caderneto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      themeMode: ThemeMode.light,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Começa na aba de Categorias/Estante

  final List<Widget> _screens = [
    const NotesListScreen(),
    const EstanteScreen(),
    const CenterPlaceholderScreen(),
    const CalendarScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            // Botão central de adicionar pasta/nota rápida
            _showAddDialog(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notas'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categoria'),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF1E222B),
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Meu'),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Criar Novo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.indigo),
              title: const Text('Novo Caderno / Pasta'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para criar pasta
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add, color: Colors.indigo),
              title: const Text('Nova Nota Rápida'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditorScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// TELA 1: ESTANTE DE CADERNOS (CATEGORIA)
// ---------------------------------------------------------
class EstanteScreen extends StatelessWidget {
  const EstanteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cadernos = [
      {'title': 'Trabalho', 'image': 'assets/trabalho.png'},
      {'title': 'aprendendo...iosas de', 'image': 'assets/aprender.png'},
      {'title': 'Dividas', 'image': 'assets/dividas.png'},
      {'title': 'Anotações gerais', 'image': 'assets/anotacoes.png'},
      {'title': 'Urgências', 'image': 'assets/urgencias.png'},
      {'title': 'Inglês 💚', 'image': 'assets/ingles.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categoria', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: cadernos.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Botão Criar Pasta
              return GestureDetector(
                onTap: () {
                  // Ação criar pasta
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.indigo.shade100),
                        ),
                        child: const Center(
                          child: Icon(Icons.note_add, color: Colors.indigo, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Criar pasta', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            }

            final item = cadernos[index - 1];
            return GestureDetector(
              onLongPress: () {
                _showCadernoOptions(context, item['title']!);
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.book, size: 40, color: Colors.indigo.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCadernoOptions(BuildContext context, String nomeCaderno) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.edit), title: const Text('Alterar nome (Renomear)'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.image), title: const Text('Alterar capa'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.copy), title: const Text('Duplicar'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.sort), title: const Text('Ordenar manualmente'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.delete, color: Colors.red), title: const Text('Excluir', style: TextStyle(color: Colors.red)), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// TELA 2: LISTA DE NOTAS RÁPIDAS (ESTILO MIND NOTES)
// ---------------------------------------------------------
class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Notes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: () {})
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Barra de Nota Rápida
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: const Text('Nota rápida aqui...', style: TextStyle(color: Colors.grey)),
          ),
          // Exemplo de Nota
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              title: const Text('Engenheira e Arquiteta de Software', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Eu gostei de eu começar a trabalhar em prestar esses... \n10-16-2026 🎤'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditorScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// TELA 3: EDITOR COMPLETO DE NOTAS (COM TODAS AS BARRAS PEDIDAS)
// ---------------------------------------------------------
class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.check, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              DateFormat('MM-dd, HH:mm').format(DateTime.now()),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const Icon(Icons.edit, size: 14, color: Colors.grey),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'eu promt pra ia me g...',
                style: TextStyle(color: Colors.black, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => _showShareModal(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Titulo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escreva sua nota aqui...',
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Text('Aa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () {}),
            IconButton(icon: const Icon(Icons.looks_one), onPressed: () {}),
            IconButton(icon: const Icon(Icons.check_box_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
            IconButton(icon: const Icon(Icons.image), onPressed: () {}),
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
            IconButton(icon: const Icon(Icons.grid_on), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.alarm), title: const Text('add lembrete'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.push_pin), title: const Text('PIN'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.desktop_mac), title: const Text('Adicionar à tela inicial'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.lock), title: const Text('Fechadura'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.picture_as_pdf), title: const Text('Exportar para PDF'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.star), title: const Text('Adicionar aos favoritos'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.archive), title: const Text('Arquivo'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.delete), title: const Text('Excluir'), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 180,
        child: Column(
          children: [
            const Text('Compartilhar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _shareOption(Icons.text_fields, 'Somente texto'),
                _shareOption(Icons.image, 'Como imagem'),
                _shareOption(Icons.picture_as_pdf, 'Como PDF'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(icon, color: Colors.indigo),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// ---------------------------------------------------------
// TELA 4: CALENDÁRIO GLOBAL (BRASÍLIA / DF E MUNDO)
// ---------------------------------------------------------
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário Global - Brasília/DF')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 64, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text('Fuso Horário Atual: Brasília (DF) - UTC-3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()), style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// TELA 5: MENU CONFIGURAÇÕES / CONTA (MEU)
// ---------------------------------------------------------
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações & Perfil')),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Rafaela Abreu'),
            accountEmail: Text('sincronizado@gmail.com'),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.indigo)),
          ),
          SwitchListTile(
            title: const Text('Modo Escuro / Claro'),
            value: false,
            onChanged: (val) {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Fechadura e Senha (App Lock)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: const Text('Português (Brasil)'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sincronização com Gmail (Backup)'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class CenterPlaceholderScreen extends StatelessWidget {
  const CenterPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox();
}
