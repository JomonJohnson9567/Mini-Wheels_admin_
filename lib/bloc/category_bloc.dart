import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<DocumentSnapshot> _allCategories = [];

  CategoryBloc() : super(CategoryLoadingState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<EditCategoryEvent>(_onEditCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<SearchCategoryEvent>(_onSearchCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoadingState());
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('name')
        .get();

    _allCategories = snapshot.docs;
    emit(CategoryLoadedState(_allCategories));
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': event.name,
      });
      add(LoadCategoriesEvent());
    } catch (error) {
      // Keep current state but log for visibility during development
      // You can emit a dedicated failure state if you want to show UI feedback
      // e.g., emit(CategoryErrorState(error.toString()));
      // For now, just print so the developer sees the issue in the console
      // and the UI remains stable.
      // ignore: avoid_print
      print('Failed to add category: $error');
    }
  }

  Future<void> _onEditCategory(
    EditCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(event.id)
        .update({'name': event.newName});
    add(LoadCategoriesEvent());
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(event.id)
        .delete();
    add(LoadCategoriesEvent());
  }

  void _onSearchCategory(
    SearchCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    final filtered = _allCategories.where((doc) {
      final name = (doc['name'] as String).toLowerCase();
      return name.contains(event.query.toLowerCase());
    }).toList();

    emit(CategoryLoadedState(filtered));
  }
}
