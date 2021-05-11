import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/Controllers/firestore/DataBase.dart';
import 'package:project/constants_colors.dart';
import 'package:project/locale_language/localization_delegate.dart';
import 'package:project/models/hotel.dart';
import 'package:project/models/users.dart';
import 'package:project/view/details_screens/hotel_details.dart';

class FavoritesHotels extends StatefulWidget {
  @override
  _FavoritesHotelsState createState() => _FavoritesHotelsState();

  FavoritesHotels();
}

class _FavoritesHotelsState extends State<FavoritesHotels> {
  _FavoritesHotelsState();

  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    return StreamBuilder(
        stream: AppLocalization.of(context).locale.languageCode == "ar"
            ? DataBase().getFavoriteHotelAr(Travelers(
                id: currentUser,
              ))
            : DataBase().getFavoriteHotel(Travelers(
                id: currentUser,
              )),
        builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot?.data?.isEmpty ?? true) {
            return AppLocalization.of(context).locale.languageCode == "ar"
                ? Center(child: Text("لا يوجد مفضلات"))
                : Center(child: Text("No Favorites"));
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Hotel hotel = snapshot.data[index];
                  var isFav = hotel.favHotels.contains(currentUser);
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                      bottom: 5,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelsDetailsScreen(
                                      hotel: hotel,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                  left: AppLocalization.of(context)
                                              .locale
                                              .languageCode ==
                                          "ar"
                                      ? Radius.circular(0)
                                      : Radius.circular(15),
                                  right: AppLocalization.of(context)
                                              .locale
                                              .languageCode ==
                                          "ar"
                                      ? Radius.circular(15)
                                      : Radius.circular(0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(hotel.images[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: AppLocalization.of(context)
                                                    .locale
                                                    .languageCode ==
                                                "ar"
                                            ? EdgeInsets.only(
                                                right: 12, top: 12)
                                            : EdgeInsets.only(
                                                left: 12, top: 12),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: AutoSizeText(
                                            hotel.hotelName,
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: AppLocalization.of(context)
                                                    .locale
                                                    .languageCode ==
                                                'ar'
                                            ? const EdgeInsets.only(
                                                right: 9,
                                              )
                                            : const EdgeInsets.only(
                                                left: 9, top: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_sharp,
                                              color: primaryColor,
                                              size: 16,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: AutoSizeText(
                                                '${hotel.hotelCountry}, ${hotel.hotelCity}',
                                                style: TextStyle(),
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: AppLocalization.of(context)
                                                    .locale
                                                    .languageCode ==
                                                "ar"
                                            ? const EdgeInsets.only(
                                                right: 12,
                                              )
                                            : const EdgeInsets.only(
                                                left: 12, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${hotel.priceOfDay.toInt()}' +
                                                  ' ${AppLocalization.of(context).locale.languageCode == "ar" ? "\جنيه" : "\EGP"}',
                                              style: TextStyle(
                                                color: pink600Color
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: AppLocalization.of(context)
                                                .locale
                                                .languageCode ==
                                            "ar"
                                        ? const EdgeInsets.only(
                                            bottom: 14, left: 6)
                                        : const EdgeInsets.only(
                                            bottom: 16, right: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.favorite),
                                          color: redAccentColor,
                                          onPressed: () {
                                            setState(() {
                                              isFav = !isFav;
                                              AppLocalization.of(context)
                                                          .locale
                                                          .languageCode ==
                                                      "ar"
                                                  ? deleteFavorite(
                                                      hotel.hotelId,
                                                      currentUser)
                                                  : deleteFavorite(
                                                      hotel.hotelId,
                                                      currentUser);
                                            });
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star_rate_rounded,
                                              size: 19,
                                              color: orangeColor,
                                            ),
                                            Text(
                                              '${hotel.hotelRate}',
                                              style: TextStyle(
                                                  color: grey700Color,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else
            return null;
        });
  }

  Future deleteFavorite(hotelId, currentUser) async {
    await DataBase()
        .removeFavoritesHotel(hotelId: hotelId, travellerId: currentUser);
    await DataBase()
        .removeFavoritesHotelAr(hotelId: hotelId, travellerId: currentUser);
  }
}
