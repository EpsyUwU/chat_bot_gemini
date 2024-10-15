import 'package:flutter/material.dart';
import 'package:flutter_challenges/core/utils/basic_models.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';
import 'package:flutter_challenges/display/widgets/home/student_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Home(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Student> students = [
      Student(
        name: 'Ángel Manuel Bautista Vázquez',
        id: 'Matricula: 213347',
        tel: 'tel:9613599651',
        sms: 'sms:9613599651',
      ),
      Student(
        name: 'Carlos Esteban Rivera Perez',
        id: 'Matricula: 213530',
        tel: 'tel:9613286990',
        sms: 'sms:9613286990',
      ),
      Student(
        name: 'Rogelio Emanuel Roque Morales',
        id: 'Matricula: 213532',
        tel: 'tel:9512198832',
        sms: 'sms:9512198832',
      ),
    ];

    return AppScaffold(
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: students.map((student) {
            return StudentCard(
              name: student.name,
              id: student.id,
              tel: student.tel,
              sms: student.sms,
            );
          }).toList(),
        ),
      ),
    );
  }
}
