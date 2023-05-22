import 'package:townhall/Models/models.dart';
import 'package:townhall/services/reportService.dart';
import 'package:townhall/services/reportService.dart';
import 'package:townhall/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/widgets/background.dart';
import '../widgets/widgets.dart';

class ReportScreenAlone extends StatefulWidget {
  final int idReport;
  const ReportScreenAlone({required this.idReport});

  @override
  State<ReportScreenAlone> createState() =>
      ReportScreenAloneState(idReport: idReport);
}

class ReportScreenAloneState extends State<ReportScreenAlone> {
  final int idReport;
  ReportScreenAloneState({required this.idReport});

  final reportService = ReportService();
  final userService = UserService();

  Report appointmentBuscar = Report();
  Report appointments = Report();
  String user = "";
  int cont = 0;
  bool desactivate = true;

  Future getReport() async {
    await reportService.getReport(idReport);
    setState(() {
      appointments = reportService.report;
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
    getReport();
    //getUser();
    // getFamilies();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'managerscreen');
      } else {
        Navigator.pushReplacementNamed(context, 'reportscreenAlone');
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
          Text(
            'Report details',
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
        centerTitle: true,
      ),
      body: Background(
        child: reportService.isLoading
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
                          child: buildListView(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  //BUILD LIST
  Widget buildListView(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Card(
            elevation: 25,
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
                    children: [
                      Expanded(
                        child: Text(
                          '${appointmentBuscar.data! != null ? appointmentBuscar.data! : appointmentBuscar.data!}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black),
                  Text(
                    '${appointmentBuscar.resolution == true ? 'Resolved' : 'Not Resolved'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  onPressed: () async {
                    reportService.deleteReport('${appointmentBuscar.id}');
                    Navigator.pushReplacementNamed(
                        context, 'reportscreenAlone');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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
