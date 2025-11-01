import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<DocumentSnapshot> categories;
  CategoryLoadedState(this.categories);
}

class CategoryErrorState extends CategoryState {
  final String message;
  final List<DocumentSnapshot> categories;
  CategoryErrorState(this.message, this.categories);
}
