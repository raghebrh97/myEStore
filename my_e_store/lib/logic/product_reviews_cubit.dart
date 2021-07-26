
import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_e_store/data/product_review_repository.dart';
import 'package:my_e_store/data/product_reviews_model.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/general_states.dart';

class ProductReviewsCubit extends Cubit<GeneralStates> {
  ProductReviewRepository productReviewRepository;
  ProductReviewsCubit(this.productReviewRepository) : super(InitialState());
  List<ProductReview> reviewsList;
  ProductReview userReview;
  Map<String, List<ProductReview>> filteredReviews;
  double productRate;

  Future<void> getProductReviews() async {
    try {
      reviewsList = await productReviewRepository.getProductReview();
      filterReviewByProductId();
    } catch (e) {
      print(e.message);
      throw (e);
    }
  }

  Future<void> addProductReview(String rate , String comment , String productName) async {
    try {
      emit(InitialState());
      emit(LoadingState());
      userReview = await productReviewRepository.submitReview(rate, comment, productName);
      await getProductReviews();
      emit(LoadedState(userReview));
    } catch (e) {
      emit(ErrorState(e.toString()));
      throw (e);
    }
  }

  void filterReviewByProductId() {
    reviewsList.sort((a, b) {
      return a.productName.trim().compareTo(b.productName.trim());
    });

    filteredReviews = groupBy(reviewsList,
        (ProductReview productReview) => productReview.productName.trim());
  }


  double getProductRate(Product product) {
    double rate = 0.0;
    int count = 0;

    reviewsList.forEach((review) {
      if (review.productName.trim() == product.productName.trim()) {
        rate += double.parse(review.rate);
        count += 1;
      }
    });
    productRate = rate / count;
    return productRate;
  }

  Map<String, List<ProductReview>> get getFilteredReviews {
    return filteredReviews;
  }


}
