import 'package:employee_record/data/local/database/app_database.dart';
import 'package:employee_record/data/local/database/employee_dao.dart';
import 'package:employee_record/data/services/employee_service.dart';
import 'package:employee_record/data/repositories/employee_repository.dart';
import 'package:employee_record/presentation/blocs/bloc/employee_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> getBlocProviders() {
  return [
    BlocProvider<EmployeeBloc>(
      create: (context) => EmployeeBloc(
        EmployeeRepository(EmployeeService(EmployeeDao(AppDatabase()))),
      ),
    ),
  ];
}
