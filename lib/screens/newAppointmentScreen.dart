import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:townhall/models/models.dart';
import 'package:townhall/providers/appointment_form_provider.dart';
import 'package:townhall/providers/department_form_provider.dart';
import 'package:townhall/screens/screens.dart';
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
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
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
  User user = User();
  List<Department> departments = [];
  final departmentService = DepartmentService();

  DateTime selectedDate =
      DateTime(10); // Variable para almacenar la fecha seleccionada

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial del selector
      firstDate: DateTime(2020), // Fecha más antigua permitida
      lastDate: DateTime(2025), // Fecha más reciente permitida
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getDepartments() async {
    await departmentService.getListDepartments();
    setState(() {
      departments = departmentService.departments;
      print("ES ESTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      print(departments[0].name);
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
    final appointmentForm = Provider.of<AppointmentFormProvider>(context);
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
            TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2070, 6, 7),
                      onChanged: (value) => appointmentForm.date = value,
                      currentTime: DateTime.now(),
                      locale: LocaleType.es);
                },
                child: Text(
                  'Date',
                  style: TextStyle(color: Colors.blue),
                )),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                DatePicker.showTimePicker(
                  context,
                  showTitleActions: true,
                  onChanged: (time) {
                    appointmentForm.date = time;
                    // Puedes hacer algo con la hora seleccionada aquí
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.es,
                );
              },
              child: Text(
                'Seleccionar Hora',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 30),
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
                appointmentForm.idDepartment = (value?.id)!;
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
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      appointmentForm.isLoading ? 'Wait' : 'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: appointmentForm.isLoading
                    ? null
                    : () async {
                        if (appointmentForm.date.isUtc ||
                            appointmentForm.hour.isEmpty ||
                            appointmentForm.idDepartment == 0) {
                          customToast("Fiels can't be empty", context);
                        } else {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

                          if (!appointmentForm.isValidForm()) return;

                          appointmentForm.isLoading = true;
                          int idUser = await AuthService().readId();
                          // TODO: validar si el login es correcto
                          final String? errorMessage = await userService.update(
                              appointmentForm.date.toString(),
                              appointmentForm.hour,
                              appointmentForm.idDepartment.toString(),
                              idUser.toString(),
                              idUser.toString());

                          if (errorMessage == '201') {
                            customToast('Updated', context);
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
      backgroundColor: Colors.deepPurple,
      alignment: Alignment.topCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 3),
      animation: StyledToastAnimation.slideFromBottom,
      context: context,
    );
  }
}
