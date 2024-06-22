import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_service_event.dart';
part 'auth_service_state.dart';

class AuthServiceBloc extends Bloc<AuthServiceEvent, AuthServiceState> {
  final _fireAuthInstance = FirebaseAuth.instance;
  final _fireStoreInstance = FirebaseFirestore.instance;

  AuthServiceBloc() : super(AuthServiceInitial()) {
    on<AuthServiceEvent>((event, emit) {});

    on<SignIn>((event, emit) async {
      try {
        await _fireAuthInstance.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        //для того чтобы получить имя пользователя
        //(это нельзя сделать через FirebaseAuth тк там такого поля даже нету)
        await for(var snapshot in _fireStoreInstance.collection('users').snapshots())
        {
          for(var user in snapshot.docs)
          {
            if(user['email'] == event.email)
            {
              //если получаем имя через Firebase, то можно и email заодно :)
              String email = user['email'], name = user['name'];
              emit(UserCreds(name, email));
              return;
            }
          }
        }
      } on FirebaseException catch (e) {
        throw Exception(e);
      }
    });

    on<SignUp>((event, emit) async {
      try {
        await _fireAuthInstance.createUserWithEmailAndPassword(
            email: event.email, password: event.password);

        Map<String, dynamic> user = {
          'name': event.name,
          'email': event.email,
        };
        await _fireStoreInstance.collection('users').add(user);

        emit(UserCreds(event.name, event.email));
      } on FirebaseAuthException catch (e) {
        throw Exception(e);
      }
    });
  }
}
