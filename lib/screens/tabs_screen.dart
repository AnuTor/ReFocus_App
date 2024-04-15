import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../providers/routes.dart';
import './routes_screen.dart';
import './profile_screen.dart';
//import './tools_screen.dart';
import './main_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void setupPushNotifications() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    messaging.subscribeToTopic('Test');
  }

  @override
  void initState() {
    _pages = [
      {
        'page': const MainScreen(),
        'title': 'Inicio',
      },
      {
        'page': const RoutesScreen(),
        'title': 'Rutas',
      },
      // {
      //   'page': const ToolsScreen(),
      //   'title': 'Herramientas',
      // },
      {
        'page': const ProfileScreen(),
        'title': 'Perfil',
      },
    ];
    super.initState();
    setupPushNotifications();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showAboutUsSheet(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double availableHeight = screenHeight - statusBarHeight;

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: availableHeight,
          ),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    "Acerca de",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                    "La presente aplicación fue diseñada y desarrollada en el marco del Proyecto Integrador para la carrera de grado Ingeniería Biomédica de la Universidad Nacional de Córdoba por los desarrolladores Franco Tomás García y Alejo González Pignol. La misma forma parte del Proyecto de Investigación denominado “Construcción de una aplicación móvil para el entrenamiento de estrategias cognitivas de regulación emocional: Un estudio de eficacia” que se desarrolla en el Instituto de Organizaciones Saludables de la Universidad Siglo 21 (Córdoba, Argentina), coordinado por el Dr. Leonardo Medrano y el Lic. Pablo Ezequiel Flores Kanter. El objetivo principal de la Investigación es: Evaluar la eficacia de una aplicación móvil para el entrenamiento de estrategias cognitivas de regulación emocional.",
                    textAlign: TextAlign.justify),
                const SizedBox(height: 10),
                const Text(
                  "Directores del proyecto y encargados de los contenidos:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                    "Pablo Ezequiel Flores Kanter: Licenciado en Psicología por la Universidad Nacional de Córdoba y Magister en Neurociencias por la Universidad Nacional Arturo Jauretche de Buenos Aires. Es investigador en psicología y becario del Consejo Nacional de Investigaciones Científicas y Técnicas (CONICET).",
                    textAlign: TextAlign.justify),
                const Text(
                    "Leonardo Adrián Medrano: Licenciado y Doctor en Psicología por la Universidad Nacional de Córdoba. Es investigador en psicología y profesor titular en la Facultad de Psicología de Universidad Nacional de Córdoba.",
                    textAlign: TextAlign.justify),
                const SizedBox(height: 10),
                const Text(
                  "Ingenieros encargados del diseño y desarrollo de la App:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                    "Alejo González Pignol: Estudiante de Ingeniería Biomédica de la Universidad Nacional de Córdoba. Gestor de Proyectos y QA. Desarrollador en Flutter.",
                    textAlign: TextAlign.justify),
                const Text(
                    "Franco Tomás García: Estudiante de Ingeniería Biomédica de la Universidad Nacional de Córdoba. Gestor de Proyectos. Científico de Datos y Desarrollador en Python y Flutter.",
                    textAlign: TextAlign.justify),
                const SizedBox(height: 10),
                const Text(
                  "Encargada de elaborar el material de Relajación:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                    "Magdalena Biota: Traductora pública en lengua inglesa (UNLP) formada en gestión de bibliotecas (UCES) y tesista doctoral en ciencias sociales y humanas (UNQ). Integra el CONICET y forma parte como colaboradora del Instituto de Literatura Argentina “Ricardo Rojas” (UBA). Desde 2018 dicta clases de yoga y meditación en el Programa Puntos Culturales de la Municipalidad de Avellaneda, Provincia de Buenos Aires.",
                    textAlign: TextAlign.justify),
                const SizedBox(height: 10),
                const Text(
                  "Consultas, inquietudes y opiniones dirigirse a:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Pablo Ezequiel Flores Kanter"),
                const Text("Email: ezequielfk@gmail.com"),
                const Text("Celular: +5493513849201"),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Refocus 1.0.0",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Routes>(context, listen: false).fetchdata();
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: [
          _selectedPageIndex == 3
              ? DropdownButton(
                  underline: Container(),
                  icon: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'logout',
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Cerrar sesión'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (itemIdentifier) {
                    if (itemIdentifier == 'logout') {
                      Provider.of<Routes>(context, listen: false).cleandata();
                      FirebaseAuth.instance.signOut();
                    }
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Theme.of(context).iconTheme.color,
                    //color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    _showAboutUsSheet(context);
                  },
                ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.rocket_outlined),
            activeIcon: const Icon(Icons.rocket),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.route_outlined),
            activeIcon: const Icon(Icons.route),
            label: 'Rutas',
          ),
          // BottomNavigationBarItem(
          //   backgroundColor: Theme.of(context).colorScheme.primary,
          //   icon: const Icon(Icons.build_outlined),
          //   activeIcon: const Icon(Icons.build),
          //   label: 'Herramientas',
          // ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
