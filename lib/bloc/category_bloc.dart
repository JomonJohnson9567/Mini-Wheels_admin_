import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/core/utils/cloudinary_service.dart';
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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('name')
          .get();

      _allCategories = snapshot.docs;
      emit(CategoryLoadedState(_allCategories));
    } catch (error) {
      emit(
        CategoryErrorState(
          'Failed to load categories: ${error.toString()}',
          _allCategories,
        ),
      );
    }
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
        emit(
          CategoryErrorState(
            'Category "${event.name}" already exists!',
            _allCategories,
          ),
        );
        return;
      }

      // Upload image to Cloudinary if provided
      String? imageUrl;
      if (event.imageBytes != null && event.imageName != null) {
        try {
          imageUrl = await CloudinaryService.uploadImage(
            event.imageBytes!,
            event.imageName!,
          );
        } catch (error) {
          emit(
            CategoryErrorState(
              'Failed to upload image: ${error.toString()}',
              _allCategories,
            ),
          );
          return;
        }
      }

      // Add to Firestore
      final categoryData = <String, dynamic>{
        'name': event.name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (imageUrl != null) {
        categoryData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('categories')
          .add(categoryData);

      // Reload categories
      add(LoadCategoriesEvent());
    } catch (error) {
      emit(
        CategoryErrorState(
          'Failed to add category: ${error.toString()}',
          _allCategories,
        ),
      );
    }
  }

  Future<void> _onEditCategory(
    EditCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final updateData = <String, dynamic>{
        'name': event.newName.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Upload new image if provided
      if (event.imageBytes != null && event.imageName != null) {
        try {
          final imageUrl = await CloudinaryService.uploadImage(
            event.imageBytes!,
            event.imageName!,
          );
          updateData['imageUrl'] = imageUrl;
        } catch (error) {
          emit(
            CategoryErrorState(
              'Failed to upload image: ${error.toString()}',
              _allCategories,
            ),
          );
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(event.id)
          .update(updateData);

      // Reload categories
      add(LoadCategoriesEvent());
    } catch (error) {
      emit(
        CategoryErrorState(
          'Failed to update category: ${error.toString()}',
          _allCategories,
        ),
      );
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(event.id)
          .delete();
      add(LoadCategoriesEvent());
    } catch (error) {
      emit(
        CategoryErrorState(
          'Failed to delete category: ${error.toString()}',
          _allCategories,
        ),
      );
    }
  }

  void _onSearchCategory(
    SearchCategoryEvent event,
    Emitter<CategoryState> emit,
  ) {
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(CategoryLoadedState(_allCategories));
      return;
    }

    final filtered = _allCategories.where((doc) {
      final name = (doc['name'] as String).toLowerCase();
      return name.contains(query);
    }).toList();

    emit(CategoryLoadedState(filtered));
  }
}
