// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pingo_learn_news_app/core/utils/type_defs.dart';
// import '../../../core/constants/firebase_constants.dart';
// import '../../../core/error/failure.dart';
// import 'package:fpdart/fpdart.dart';
// import '../../../models/user_model.dart';
//
// class AuthRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;
//
//   AuthRepository({
//     required FirebaseFirestore firestore,
//     required FirebaseAuth auth,
//   })  : _auth = auth,
//         _firestore = firestore;
//
//   CollectionReference get _users =>
//       _firestore.collection(FirebaseConstants.usersCollection);
//
//   Stream<User?> get authStateChange => _auth.authStateChanges();
//
//   FutureEither<UserModel> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       UserModel userModel =
//           await getUserData(uid: userCredential.user!.uid).first;
//
//       return right(userModel);
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }
//
//   FutureEither<UserModel> signUpWithEmailAndPassword({
//     required String userName,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       UserModel userModel = UserModel(
//         name: userName,
//         uid: userCredential.user!.uid,
//         country: '',
//         email: email,
//         profilePic: '',
//       );
//       return right(userModel);
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }
//
//   FutureVoid logOut() async {
//     try {
//       return right(await _auth.signOut());
//     } on FirebaseException catch (e) {
//       throw e.message!;
//     } catch (e) {
//       return left(Failure(e.toString()));
//     }
//   }
//
//   Stream<UserModel> getUserData({required String uid}) {
//     return _users.doc(uid).snapshots().map(
//           (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
//         );
//   }
// }
