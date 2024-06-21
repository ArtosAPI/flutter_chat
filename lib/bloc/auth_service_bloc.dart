import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_service_event.dart';
part 'auth_service_state.dart';

class AuthServiceBloc extends Bloc<AuthServiceEvent, AuthServiceState> {
  final _instance = FirebaseAuth.instance;

  AuthServiceBloc() : super(AuthServiceInitial()) {
    on<AuthServiceEvent>((event, emit) {});

    on<SignIn>((event, emit) async {
      try {
        await _instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        emit(UserCreds(event.email, event.password));
      } on FirebaseAuthException catch (e) {
        throw Exception(e);
      }
    });
  }
}
