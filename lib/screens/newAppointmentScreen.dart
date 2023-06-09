import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/models/models.dart';
import 'package:townhall/providers/appointment_form_provider.dart';
import 'package:townhall/providers/department_form_provider.dart';
import 'package:townhall/screens/screens.dart';
import 'package:townhall/services/appointmentService.dart';
import 'package:townhall/services/departmentService.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreen();
}

class _NewAppointmentScreen extends State<NewAppointmentScreen> {
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
                  Text('New Appointment',
                      style: Theme.of(context).textTheme.headline4),
                  SizedBox(height: 30),
                  ChangeNotifierProvider(
                      create: (_) => AppointmentFormProvider(), child: _Form())
                ],
              )),
              SizedBox(height: 50),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'userscreen'),
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
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __Form();
}

class __Form extends State<_Form> {
  final userService = UserService();
  final appointmentService = AppointmentService();
  final departmentService = DepartmentService();
  List<Department> departments = [];
  List<User> managers = [];
  List<Appointment> appointments = [];
  User user = User();
  String selectedButton = '';
  DateTime selectedDate =
      DateTime(10); // Variable para almacenar la fecha seleccionada
  List<String> hoursOcu = [];
  var appointmentForm = null;

  Future<void> _selectDate(
      BuildContext context, DateTime select, int id) async {
    List<String> hours = ['09:00', '10:00', '11:00', '12:00'];
    List<Appointment> appDep = [];
    List<Appointment> app = [];
    List<String> disps = [];
    List<String> fechaS = select.toString().split(' ');

    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].idDepartment == id) {
        appDep.add(appointments[i]);
      }
    }
    print(appDep);
    for (int i = 0; i < appDep.length; i++) {
      List<String> fechaD = appDep[i].date.toString().split('T');

      if (fechaD[0] == fechaS[0]) {
        app.add(appDep[i]);
      }
    }

    for (int f = 0; f < app.length; f++) {
      String h = app[f].hour!.substring(0, 5);

      for (int i = 0; i < hours.length; i++) {
        if (hours.contains(h)) {
          disps.add(h);
          break;
        }
      }
    }
    setState(() {
      print('disponibles' + disps.toString());
      hoursOcu = disps;
    });
  }

  Future getDepartments() async {
    await departmentService.getListDepartments();
    setState(() {
      departments = departmentService.departments;
    });
  }

  Future getManagers() async {
    await userService.getManagers();
    setState(() {
      managers = userService.managers;
    });
  }

  Future getAppointments() async {
    await appointmentService.getListAppointments();
    setState(() {
      appointments = appointmentService.appointments;
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
    getManagers();
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentForm = Provider.of<AppointmentFormProvider>(context);
    final appointmentService = AppointmentService();
    //final departmentProvider = Provider.of<DepartmentFormProvider>(context);
    List<Department> options = [];
    if (departments.isNotEmpty) {
      for (var i = 0; i < departments.length; i++) {
        options.add(departments[i]);
      }
    }

    return Container(
      child: Form(
        key: appointmentForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            DropdownButtonFormField<Department>(
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.view_week_outlined,
                  hintText: '',
                  labelText: 'Department'),
              // value: selectedItem,
              items: options
                  .map(
                    (depart) => DropdownMenuItem(
                      value: depart,
                      child: Text(depart.name.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  appointmentForm.idDepartment = (value?.id)!;
                });
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
            Visibility(
              visible: appointmentForm.idDepartment != 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime.now().add(Duration(days: 365)),
                            onChanged: (value) {
                          appointmentForm.date = value;
                          _selectDate(
                              context, value, appointmentForm.idDepartment);
                        }, currentTime: DateTime.now(), locale: LocaleType.es);
                      },
                      child: Text(
                        'Date',
                        style: TextStyle(color: Colors.blue),
                      )),
                  Visibility(
                      visible: appointmentForm.hour != null,
                      child: Text(
                          appointmentForm.date.toString().substring(0, 10))),
                ],
              ),
            ),
            SizedBox(height: 30),
            Visibility(
              visible: appointmentForm.date != DateTime(0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Visibility(
                    visible: !_isVisible('09:00'),
                    child: buildRoundButton('09:00', appointmentForm)),
                Visibility(
                    visible: !_isVisible('10:00'),
                    child: buildRoundButton('10:00', appointmentForm)),
                Visibility(
                    visible: !_isVisible('11:00'),
                    child: buildRoundButton('11:00', appointmentForm)),
                Visibility(
                    visible: !_isVisible('12:00'),
                    child: buildRoundButton('12:00', appointmentForm)),
              ]),
            ),
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
                      appointmentForm.isLoading ? 'Wait' : 'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: appointmentForm.isLoading
                    ? null
                    : () async {
                        if (appointmentForm.date == DateTime(0) ||
                            appointmentForm.hour.isEmpty ||
                            appointmentForm.idDepartment == 0) {
                          customToast("Fiels can't be empty", context);
                        } else {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!appointmentForm.isValidForm()) return;

                          appointmentForm.isLoading = true;
                          int idUser = user.id!;
                          // TODO: validar si el login es correcto

                          List<String> da =
                              appointmentForm.date.toString().split(" ");

                          int min = 0;
                          int max = 0;

                          // managers.forEach((element) {
                          //
                          // });
                          if (managers.length > 0) {
                            max = managers.length - 1;
                            min = 1;
                          }

                          Random random = Random();

                          int randomInt = min + random.nextInt(max - min + 1);

                          final String? errorMessage =
                              await appointmentService.create(
                                  da[0],
                                  appointmentForm.hour,
                                  appointmentForm.idDepartment.toString(),
                                  managers[randomInt].id!,
                                  idUser);

                          if (errorMessage == '201') {
                            customToast('Created', context);
                            Navigator.pushReplacementNamed(
                                context, 'userscreen');
                          } else if (errorMessage == '500') {
                            // TODO: mostrar error en pantalla
                            customToast('User registered', context);

                            appointmentForm.isLoading = false;
                          } else {
                            customToast('Server error', context);
                          }
                        }
                      })
          ],
        ),
      ),
    );
  }

  Widget buildRoundButton(
      String buttonNumber, AppointmentFormProvider _appointmentForm) {
    bool isSelected = selectedButton == buttonNumber;
    bool activate = hoursOcu.contains(selectedButton);

    return InkWell(
      enableFeedback: activate,
      onTap: () {
        setState(() {
          selectedButton = buttonNumber;
          _appointmentForm.hour = selectedButton;
          print(_appointmentForm.hour);
          appointmentForm = _appointmentForm;
        });
      },
      child: Container(
        width: 65,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        child: Center(
          child: Text(
            buttonNumber.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  bool _isVisible(String _hour) {
    print('__VISIBLE__');
    print('horaa ' + _hour);
    print('horas ' + hoursOcu.toString());
    bool activate = hoursOcu.contains(_hour);
    print(activate);
    return activate;
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
