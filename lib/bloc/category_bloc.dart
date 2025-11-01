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
      // Check for duplicate category (case-insensitive)
      final categoryName = event.name.trim().toLowerCase();
      final isDuplicate = _allCategories.any((doc) {
        final existingName = (doc['name'] as String).toLowerCase().trim();
        return existingName == categoryName;
      });

      if (isDuplicate) {
        // Get current categories from the last loaded state
        final currentCategories = _allCategories;
        emit(
          CategoryErrorState(
            'Category "${event.name}" already exists!',
            currentCategories,
          ),
        );
        // Emit back to loaded state after showing error
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            emit(CategoryLoadedState(currentCategories));
          }
        });
        return;
      }

      // If not duplicate, add to Firestore
      await FirebaseFirestore.instance.collection('categories').add({
        'name': event.name.trim(),
      });
      add(LoadCategoriesEvent());
    } catch (error) {
      // Handle Firestore errors
      final currentCategories = _allCategories;
      emit(
        CategoryErrorState(
          'Failed to add category: ${error.toString()}',
          currentCategories,
        ),
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) {
          emit(CategoryLoadedState(currentCategories));
        }
      });
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
