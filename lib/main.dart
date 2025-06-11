import 'package:flutter/material.dart';
import 'dart:math';

const int num = 3;
const String student = "Сафронов Дмитрий Иванович";

///Модель для хранения данных уравнения
class QuadraticEquation 
{
  final double a;
  final double b;
  final double c;
  final bool dataProcessingAllowed;

  QuadraticEquation({
    required this.a,
    required this.b,
    required this.c,
    required this.dataProcessingAllowed,
  });
}


///Первый экран с формой ввода
class InputScreen extends StatefulWidget 
{
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
{
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _dataProcessingAllowed = false;

  @override
  void dispose() 
  {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  //Считываем данные и переходим над второе экран
  void _submitForm() 
  {
    if (_formKey.currentState!.validate() && _dataProcessingAllowed)
    {
      final equation = QuadraticEquation(
        a: double.parse(_aController.text),
        b: double.parse(_bController.text),
        c: double.parse(_cController.text),
        dataProcessingAllowed: _dataProcessingAllowed,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(equation: equation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: Text('Лабораторная работа №$num', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              Text( "Выполнил: $student", style: TextStyle(fontSize: 20), textAlign: TextAlign.left),
              Text( "Квадратное уравнение", style: TextStyle(fontSize: 25)),
              TextFormField(
                controller: _aController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Коэффициент a'),
                validator: (value) 
                {
                  if (value == null || value.isEmpty) 
                  {
                    return 'Введите коэффициент';
                  }
                  if (double.tryParse(value) == null) 
                  {
                    return 'Введите число';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _bController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Коэффициент b'),
                validator: (value) 
                {
                    if (value == null || value.isEmpty)
                    {
                        return 'Введите коэффициент';
                    }
                    if (double.tryParse(value) == null) {
                        return 'Введите число';
                    }
                    return null;
                },
              ),
              TextFormField(
                controller: _cController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Коэффициент c'),
                validator: (value) 
                {
                    if (value == null || value.isEmpty)
                    {
                        return 'Введите коэффициент';
                    }
                    if (double.tryParse(value) == null)
                    {
                        return 'Введите число';
                    }

                    return null;
                },
              ),
              CheckboxListTile(
                title: Text('Согласен на обработку данных'),
                value: _dataProcessingAllowed,
                onChanged: (bool? value) 
                {
                  setState(() 
                  {
                    _dataProcessingAllowed = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



///Второй экран с результатами;
class ResultsScreen extends StatelessWidget 
{
  final QuadraticEquation equation;

  const ResultsScreen({required this.equation});

    List<String> _calculateRoots()
    {
     final a = equation.a;
     final b = equation.b;
     final c = equation.c;
    
     if (a == 0) {
       return ['Уравнение не квадратное (a = 0)'];
     }
    
     final discriminant = b * b - 4 * a * c;
     
     if (discriminant > 0) {
       final sqrtDiscriminant = sqrt(discriminant);
       final x1 = (-b + sqrtDiscriminant) / (2 * a);
       final x2 = (-b - sqrtDiscriminant) / (2 * a);
       return [
         'Дискриминант: ${discriminant.toStringAsFixed(2)}',
         'Два действительных корня:',
         'x₁ = ${x1.toStringAsFixed(2)}',
         'x₂ = ${x2.toStringAsFixed(2)}',
       ];
     } else if (discriminant == 0) {
       final x = -b / (2 * a);
       return [
         'Дискриминант: ${discriminant.toStringAsFixed(2)}',
         'Один действительный корень:',
         'x = ${x.toStringAsFixed(2)}',
       ];
     } else {
       final realPart = -b / (2 * a);
       final imaginaryPart = sqrt(-discriminant) / (2 * a);
       return [
         'Дискриминант: ${discriminant.toStringAsFixed(2)}',
         'Действительных корней нет',
         'Комплексные корни:',
         'x₁ = ${realPart.toStringAsFixed(2)} + ${imaginaryPart.toStringAsFixed(2)}i',
         'x₂ = ${realPart.toStringAsFixed(2)} - ${imaginaryPart.toStringAsFixed(2)}i',
       ];
     }
    }

    @override
  Widget build(BuildContext context) 
  {
    final results = _calculateRoots();

    return Scaffold(
      appBar: AppBar(title: Text('Результаты')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Уравнение: ${equation.a}x² + ${equation.b}x + ${equation.c} = 0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...results.map((result) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(result, style: TextStyle(fontSize: 16)),
            )).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}


///Основной файл приложения
void main() 
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget 
{
  //Функция для создания заголовка;
  Widget buildAppBar(String title, {bool bold = false})
  {
    return SliverAppBar(
      title: Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'Квадратное уравнение',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputScreen(),
    );
  }
}