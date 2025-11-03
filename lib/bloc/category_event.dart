import 'dart:typed_data';

abstract class CategoryEvent {}

class LoadCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String name;
  final Uint8List? imageBytes;
  final String? imageName;

  AddCategoryEvent(this.name, {this.imageBytes, this.imageName});
}

class EditCategoryEvent extends CategoryEvent {
  final String id;
  final String newName;
  final Uint8List? imageBytes;
  final String? imageName;

  EditCategoryEvent(this.id, this.newName, {this.imageBytes, this.imageName});
}

class DeleteCategoryEvent extends CategoryEvent {
  final String id;
  DeleteCategoryEvent(this.id);
}

class SearchCategoryEvent extends CategoryEvent {
  final String query;
  SearchCategoryEvent(this.query);
}
