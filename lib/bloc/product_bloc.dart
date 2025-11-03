import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/product_event.dart';
import 'package:mini_wheelz/bloc/product_state.dart';
import 'package:mini_wheelz/core/utils/cloudinary_service.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductInitial()) {
    on<AddProductSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
    AddProductSubmitted event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductLoading());

    try {
      final imageUrls = await CloudinaryService.uploadImages(
        event.imageBytes,
        event.imageNames,
      );

      await FirebaseFirestore.instance.collection('products').add({
        'name': event.name,
        'description': event.description,
        'price': event.price,
        'quantity': event.quantity,
        'unit': event.unit,
        'category': event.category,
        'images': imageUrls,
        'timestamp': Timestamp.now(),
      });

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductFailure("Error: $e"));
    }
  }
}
