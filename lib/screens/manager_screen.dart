import 'package:townhall/Models/models.dart';
import 'package:townhall/services/appointmentService.dart';
import 'package:townhall/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/widgets/background.dart';
import '../widgets/widgets.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final appointmentService = AppointmentService();
  final userService = UserService();

  List<Appointment> appointmentBuscar = [];
  List<Appointment> appointments = [];
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getAppointments() async {
    await appointmentService
        .getAppointmentsManager(await AuthService().readId());
    setState(() {
      appointments = appointmentService.appointments;

      cont = appointments.length;
      if (cont >= 5) {
        desactivate = false;
      }

      appointmentBuscar = appointments;
      // for (int i = 0; i < appointments.length; i++) {
      //   appointmentBuscar
      //       .removeWhere((element) => (element.id == appointments[i].id));
      // }
    });
  }

  Future getUser() async {
    await userService.getUser();
    String id = await userService.getUser() as String;
    setState(() {
      user = id;
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('iniciando');
    getAppointments();
    //getUser();
    // getFamilies();
  }

  void _runFilter(String enteredKeyword) {
    List<Appointment> results = [];
    if (enteredKeyword.isEmpty) {
      results = appointments;
    } else {
      results = appointments
          .where((x) =>
              x.date!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      // articlesBuscar = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'managerscreen');
      } else {
        Navigator.pushReplacementNamed(context, 'reportscreen');
      }
    }

    // final articleService = Provider.of<ArticleService>(context, listen: false);
    // articles = articleService.articles.cast<ArticleData>();
    // for (int i = 0; i < articles.length; i++) {
    //   if (articles[i].deleted == 1) {
    //     print(articles[i]);
    //   }
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(184, 237, 243, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40.0),
          ),
        ),
        title: Row(children: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            color: Color.fromRGBO(0, 0, 0, 1),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
          Text(
            'Appointments',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
          Text(
            '$cont',
            style: const TextStyle(
                fontSize: 30, color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        centerTitle: true,
      ),
      body: Background(
        child: appointmentService.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blueGrey, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            onChanged: (value) => _runFilter(value),
                            decoration: const InputDecoration(
                              labelText: '    Search',
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          child: buildListView(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'newappointmentscreen');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Colors.blue,
        child: Icon(Icons.add_to_photos_rounded, color: Colors.white),
        constraints: BoxConstraints.tightFor(
          width: 40.0,
          height: 40.0,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.all_inbox_rounded), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.featured_play_list_outlined), label: 'Reports'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }

  //BUILD LIST
  Widget buildListView(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(30),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: appointmentBuscar.length,
      itemBuilder: (BuildContext context, index) {
        return Stack(
          children: [
            Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${appointmentBuscar[index].date != null ? appointmentBuscar[index].date!.substring(0, 10) : ''}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${appointmentBuscar[index].hour != null ? appointmentBuscar[index].hour![0].toUpperCase() + appointmentBuscar[index].hour!.substring(1) : ''}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.black),
                    Text(
                      '${appointmentBuscar[index].hour != null ? appointmentBuscar[index].hour!.substring(0, 5) : ''}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 59, 156, 236),
                  shape: BoxShape.circle,
                ),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(71, 240, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.featured_play_list_outlined),
                                  color: Colors.black,
                                  onPressed: () async {
                                    appointmentService.deleteProduct(
                                        '${appointmentBuscar[index].id}');
                                    Navigator.pushReplacementNamed(
                                        context, 'managerscreen');
                                  },
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.black,
                                  onPressed: () async {
                                    appointmentService.deleteProduct(
                                        '${appointmentBuscar[index].id}');
                                    Navigator.pushReplacementNamed(
                                        context, 'managerscreen');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 'Opcion 1') {
                          Provider.of<AuthService>(context, listen: false)
                              .logout();
                          Navigator.pushReplacementNamed(context, 'login');
                        } else if (value == 'Opcion 2') {
                          // Lógica para la opción 2
                        }
                      },
                    )),
              ),
            ),
          ],
        );
      },
    );
  }

  void customToast(String s, BuildContext context) {
    showToast(
      s,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }
}
