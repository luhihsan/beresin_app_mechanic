// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/auth_remote_datasource.dart' as _i1016;
import '../../data/datasources/service_ticket_remote_datasource.dart' as _i164;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/service_ticket_repository_impl.dart' as _i479;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../domain/repositories/service_ticket_repository.dart' as _i994;
import '../../presentation/features/ticket/cubit/auth_cubit.dart' as _i917;
import '../../presentation/features/ticket/cubit/ticket_cubit.dart' as _i647;
import 'firebase_modul.dart' as _i893;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i164.ServiceTicketRemoteDataSource>(() =>
        _i164.ServiceTicketRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i994.ServiceTicketRepository>(() =>
        _i479.ServiceTicketRepositoryImpl(
            gh<_i164.ServiceTicketRemoteDataSource>()));
    gh.lazySingleton<_i1016.AuthRemoteDataSource>(
        () => _i1016.AuthRemoteDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i974.FirebaseFirestore>(),
            ));
    gh.lazySingleton<_i1073.AuthRepository>(
        () => _i895.AuthRepositoryImpl(gh<_i1016.AuthRemoteDataSource>()));
    gh.factory<_i647.TicketCubit>(
        () => _i647.TicketCubit(gh<_i994.ServiceTicketRepository>()));
    gh.factory<_i917.AuthCubit>(
        () => _i917.AuthCubit(gh<_i1073.AuthRepository>()));
    return this;
  }
}

class _$FirebaseModule extends _i893.FirebaseModule {}
