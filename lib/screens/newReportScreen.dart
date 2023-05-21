import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/models/models.dart';
import 'package:townhall/providers/appointment_form_provider.dart';
import 'package:townhall/providers/department_form_provider.dart';
import 'package:townhall/providers/report_form_provider.dart';
import 'package:townhall/screens/screens.dart';
import 'package:townhall/services/reportService.dart';
import 'package:townhall/services/departmentService.dart';
import 'package:townhall/services/reportService.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class NewReportScreen extends StatefulWidget {
  final int idAppointment;
  const NewReportScreen({required this.idAppointment});

  @override
  State<NewReportScreen> createState() =>
      _NewReportScreen(idAppointment: idAppointment);
}

class _NewReportScreen extends State<NewReportScreen> {
  final int idAppointment;

  _NewReportScreen({required this.idAppointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                  child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('New Report',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => AppointmentFormProvider(),
                      child: _Form(idAppointment: idAppointment))
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'managerscreen'),
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(StadiumBorder())),
                  child: Text(
                    'Back',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  )),
              SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _Form extends StatefulWidget {
  final int idAppointment;
  const _Form({required this.idAppointment});

  @override
  State<_Form> createState() => __Form(idAppointment: idAppointment);
}

class __Form extends State<_Form> {
  final int idAppointment;
  __Form({required this.idAppointment});

  final userService = UserService();
  User user = User();
  List<Department> departments = [];
  final departmentService = DepartmentService();

  DateTime selectedDate =
      DateTime(10); // Variable para almacenar la fecha seleccionada

  Future getDepartments() async {
    await departmentService.getListDepartments();
    setState(() {
      departments = departmentService.departments;
    });
  }

  Future getUser() async {
    await userService.getUser();
    User us = await userService.getUser();
    setState(() {
      user = us;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    final reportForm = Provider.of<ReportFormProvider>(context);
    final reportService = ReportService();
    //final departmentProvider = Provider.of<DepartmentFormProvider>(context);
    List<dynamic> options = [
      [false, "Not Resolved"],
      [true, "Resolved"]
    ];

    return Container(
      child: Form(
        key: reportForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'data',
                  labelText: 'Data',
                  prefixIcon: Icons.summarize_rounded),
              onChanged: (value) => reportForm.data = value,
              maxLines: null,
            ),
            SizedBox(height: 30),
            SizedBox(height: 30),
            DropdownButtonFormField<dynamic>(
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.view_week_outlined,
                  hintText: '',
                  labelText: 'Resolution'),
              // value: selectedItem,
              items: options
                  .map(
                    (op) => DropdownMenuItem(
                      value: op[0],
                      child: Text(op[1].toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                reportForm.resolution = (value);
              },
              validator: (cicle) {
                if (cicle != null) {
                  return null;
                } else {
                  return 'Select a companie';
                }
              },
            ),
            SizedBox(height: 30),
            SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.blueGrey,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      reportForm.isLoading ? 'Wait' : 'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: reportForm.isLoading
                    ? null
                    : () async {
                        // if (reportForm.date.isUtc ||
                        //     reportForm.hour.isEmpty ||
                        //     reportForm.idDepartment == 0) {
                        //   customToast("Fiels can't be empty", context);
                        // } else {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!reportForm.isValidForm()) return;

                        reportForm.isLoading = true;
                        int idUser = user.id!;
                        // TODO: validar si el login es correcto
                        final String? errorMessage = await reportService.create(
                            reportForm.data,
                            reportForm.resolution,
                            idAppointment);

                        if (errorMessage == '201') {
                          customToast('Created', context);
                          Navigator.pushReplacementNamed(
                              context, 'managerscreen');
                        } else if (errorMessage == '500') {
                          // TODO: mostrar error en pantalla
                          customToast('User registered', context);

                          reportForm.isLoading = false;
                        } else {
                          customToast('Server error', context);
                        }
                        // }
                      })
          ],
        ),
      ),
    );
  }

  void customToast(String message, BuildContext context) {
    showToast(
      message,
      textStyle: const TextStyle(
        fontSize: 14,
        wordSpacing: 0.1,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textPadding: const EdgeInsets.all(23),
      fullWidth: true,
      toastHorizontalMargin: 25,
      borderRadius: BorderRadius.circular(15),
      backgroundColor: Colors.blueGrey,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}
