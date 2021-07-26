import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_e_store/data/product_reviews_model.dart';
import 'package:my_e_store/data/produtcs_model.dart';
import 'package:my_e_store/logic/general_states.dart';
import 'package:my_e_store/logic/product_reviews_cubit.dart';

class UserReviewsScreen extends StatefulWidget {
  static const String reviewsRoute = '/userReviewsRoute';
  @override
  _UserReviewsScreenState createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends State<UserReviewsScreen> {
  List<ProductReview> userReviews = [];
  TextEditingController userCommentController = TextEditingController();
  Product arg;
  String rate;
  String comment;
  bool validator = false;

  @override
  void didChangeDependencies() {
    arg = ModalRoute.of(context).settings.arguments;
    userReviews = BlocProvider.of<ProductReviewsCubit>(context, listen: false)
        .getFilteredReviews[arg.productName.toString().trim()];

    super.didChangeDependencies();
  }

  Widget addReviewButton() {
    return IconButton(
        icon: Icon(Icons.add),
        tooltip: 'Rate & Review this product',
        onPressed: () {
          showModalBottomSheet<dynamic>(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              isScrollControlled: true,
              context: context,
              builder: (ctx) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Rating'),
                            RatingBar(
                              initialRating: 0,
                              itemSize: 30,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ratingWidget: RatingWidget(
                                full: Icon(
                                  Icons.star,
                                  color: Colors.orangeAccent,
                                ),
                                half: Icon(
                                  Icons.star_half,
                                  color: Colors.orangeAccent,
                                ),
                                empty: Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              //itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              onRatingUpdate: (rating) {
                                rate = rating.toString();
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Comments'),
                              flex: 1,
                            ),
                            Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: userCommentController,
                                  decoration: InputDecoration(
                                      errorText: validator
                                          ? 'Please enter at least 4 characters'
                                          : null,
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Enter your review'),
                                  autocorrect: true,
                                  maxLength: 250,
                                  onSubmitted: (text) {
                                    comment = userCommentController.text;
                                  },
                                ))
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            comment = userCommentController.text;
                            if (comment != null &&
                                comment.isNotEmpty &&
                                rate != null &&
                                comment.length >= 4) {
                              await BlocProvider.of<ProductReviewsCubit>(
                                      context)
                                  .addProductReview(
                                      rate, comment, arg.productName)
                                  .whenComplete(() {
                                setState(() {});
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Error' , style: TextStyle(color: Colors.black),),
                                        content: Text(
                                            'Please enter at least 4 characters and make sure to rate the product before submitting'),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Dismiss'))
                                        ],
                                      ));
                            }
                          },
                          child:
                              BlocConsumer<ProductReviewsCubit, GeneralStates>(
                            builder: (context, state) {
                              if (state is InitialState) {
                                return Text(
                                  'Submit!',
                                  style: TextStyle(color: Colors.white),
                                );
                              } else if (state is LoadingState) {
                                return SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ));
                              }
                              return Text(
                                'Submit!',
                                style: TextStyle(color: Colors.white),
                              );
                            },
                            listener: (context, state) {
                              if (state is ErrorState) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: Text(
                                          'Error',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        content: Text(state.errorMessage),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Dismiss'))
                                        ],
                                      );
                                    });
                              } else if (state is LoadedState) {
                                userCommentController.clear();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  key: ValueKey('snack'),
                                  content: Text(
                                    'Your review was submitted successfully!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              minimumSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.5, 36)),
                              foregroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          addReviewButton(),
        ],
        elevation: 0,
        title: Text(
          'Reviews for ${arg.productName}',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: (userReviews?.isEmpty ?? true)
          ? Center(
              child: Text('No Reviews available for this item'),
            )
          : Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userReviews.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/default_prof.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          userReviews[index].userName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RatingBar(
                                          ignoreGestures: true,
                                          initialRating: double.parse(
                                              userReviews[index].rate),
                                          direction: Axis.horizontal,
                                          itemSize: 16,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            half: Icon(
                                              Icons.star_half,
                                              color: Colors.orangeAccent,
                                            ),
                                            empty: Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                          //itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  child: Text(userReviews[index].comment,
                                      style: TextStyle(fontSize: 15)),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                              ]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
