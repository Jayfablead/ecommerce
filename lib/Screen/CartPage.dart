import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Modal/Cartmodal.dart';
import 'package:ecommerce/Modal/DisIncrementModal.dart';
import 'package:ecommerce/Modal/IncrementModal.dart';
import 'package:ecommerce/Modal/ProfileModal.dart';
import 'package:ecommerce/Modal/RemoveCartModal.dart';
import 'package:ecommerce/Modal/ViewCartModal.dart';
import 'package:ecommerce/Provider/Authprovider.dart';
import 'package:ecommerce/Screen/CheckoutDetail.dart';
import 'package:ecommerce/Screen/ProfilePage.dart';
import 'package:ecommerce/Widget/Const.dart';
import 'package:ecommerce/Widget/Drawer.dart';
import 'package:ecommerce/Widget/buildErrorDialog.dart';
import 'package:ecommerce/Widget/loder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Databasehandler.dart';
import '../Modal/AllUserAddModal.dart';
import '../Provider/cartProvider.dart';
import '../Widget/bottombar.dart';
import 'LoginPage2.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

int age = 1;
int? newprice;
int? taxprice;
final GlobalKey<ScaffoldState> _scaffoldKeycart = GlobalKey<ScaffoldState>();
DatabaseHelper databaseHelper = DatabaseHelper();

class order {
  String? image;
  String? name;
  String? dec;
  String? price;

  order(this.image, this.name, this.price, this.dec);
}

int pricetag = 0;

bool isLoading = true;
int total = 0;
List<order> cat = [
  order(
    'https://www.transparentpng.com/thumb/-iphone-x/dO1Aqf-apple-iphone-caracteru-edsticas-especificaciones.png',
    'Samsung Mobile.. ',
    "24500",
    "Samsung Galaxy M34 price in India starts from Rs. 18,999. The lowest price of Samsung Galaxy",
  ),
  order(
    'https://www.transparentpng.com/thumb/computer/6o4Q2H-png-windows-desktop-set-software-game-coding-.png',
    'Samsung Mobile.. ',
    "24500",
    "Samsung Galaxy M34 price in India starts from Rs. 18,999. The lowest price of Samsung Galaxy",
  ),
];

class _CartPageState extends State<CartPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    ViewCartApi();

    setState(() {
      isLoading = true;
    });
    alluseraddapi();
  }

  Future<void> _fetchCartItems() async {
    List<CartItem> items = await databaseHelper.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return commanScreen(
      isLoading: isLoading,
      scaffold: Scaffold(
        bottomNavigationBar: bottombar(),
        key: _scaffoldKeycart,
        drawer: drawer1(),
        backgroundColor: bgcolor,
        body: isLoading
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: usermodal?.userId == "" || usermodal?.userId == null
                    ? Container(
                        child: FutureBuilder(
                          future: cart.getdata(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  SizedBox(height: 4.h),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              _scaffoldKeycart.currentState
                                                  ?.openDrawer();
                                            },
                                            icon: Icon(
                                              Icons.menu_rounded,
                                              size: 25.sp,
                                            )),
                                        Text(
                                          "My Cart",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontFamily: "task",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage2()));
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 1.h),
                                              child: Text(
                                                "Login",
                                                style: TextStyle(
                                                  color: Color(0xfff7941d),
                                                  fontFamily: 'task',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.sp,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  snapshot.data!.length == 0 ||
                                          snapshot.data!.length == null
                                      ? Container(
                                          height: 80.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No Data Available",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'task',
                                              fontSize: 20.sp,
                                            ),
                                          ))
                                      : Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 54.h,
                                              child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Stack(
                                                      children: [
                                                        Card(
                                                            color: Colors.white,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          2.w,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              20)),
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(3.0),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              snapshot.data![index].productImage ?? '',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              34.w,
                                                                          width:
                                                                              32.w,
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              image: DecorationImage(
                                                                                image: imageProvider,
                                                                                // fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          placeholder: (context, url) =>
                                                                              Center(child: CircularProgressIndicator()),
                                                                          errorWidget: (context, url, error) =>
                                                                              Icon(Icons.error),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          3.w,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 0.5
                                                                              .h,
                                                                          horizontal:
                                                                              0.5.w),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                1.5.h,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 1.w),
                                                                                child: SizedBox(
                                                                                  width: 45.w,
                                                                                  child: Text(
                                                                                    snapshot.data![index].productName ?? '',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: "task"),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 50.w,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                      padding: EdgeInsets.only(left: 1.w),
                                                                                      child: Container(
                                                                                        width: 47.w,
                                                                                        child: Text(
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 2,
                                                                                          snapshot.data![index].productDescription ?? '',
                                                                                          style: TextStyle(color: Colors.black87, fontSize: 12.sp, fontWeight: FontWeight.normal, fontFamily: "task"),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 1.h,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    width: 27.w,
                                                                                    height: 6.5.h,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                    ),
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            int quntity = snapshot.data![index].productQuantity!;
                                                                                            int price = snapshot.data![index].initialPrice!.toInt();
                                                                                            quntity--;
                                                                                            if (quntity > 0) {
                                                                                              int? newprice = price * quntity;
                                                                                              databaseHelper
                                                                                                  .updateQuantityCartItems(
                                                                                                CartItem(
                                                                                                  VariationTblId: snapshot.data![index].VariationTblId.toString(),
                                                                                                  Color: snapshot.data![index].Color.toString(),
                                                                                                  Size: snapshot.data![index].Size.toString(),
                                                                                                  productId: snapshot.data![index].productId.toString(),
                                                                                                  productDescription: snapshot.data![index].productDescription.toString(),
                                                                                                  id: snapshot.data![index].id,
                                                                                                  productName: snapshot.data![index].productName,
                                                                                                  productPrice: newprice.toDouble(),
                                                                                                  productQuantity: quntity,
                                                                                                  productImage: snapshot.data![index].productImage.toString(),
                                                                                                  initialPrice: snapshot.data![index].initialPrice,
                                                                                                ),
                                                                                              )
                                                                                                  .then((value) {
                                                                                                pricetag = newprice;
                                                                                                print(pricetag);
                                                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                                              }).onError((error, stackTrace) {
                                                                                                print(error.toString());
                                                                                              });
                                                                                            }
                                                                                            print("clik button");
                                                                                          },
                                                                                          child: Container(
                                                                                              height: 7.5.w,
                                                                                              width: 7.5.w,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(15),
                                                                                                color: Color(0xfff7941d),
                                                                                              ),
                                                                                              child: Icon(
                                                                                                Icons.remove,
                                                                                                size: 20.sp,
                                                                                                color: Colors.white,
                                                                                              )),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 2.5.w,
                                                                                        ),
                                                                                        Container(
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                child: Text(
                                                                                                  (snapshot.data![index].productQuantity).toString(),
                                                                                                  style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontFamily: "task",
                                                                                                    fontSize: 16.sp,
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 2.5.w,
                                                                                        ),
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            int quntity = snapshot.data![index].productQuantity!;
                                                                                            int price = snapshot.data![index].initialPrice!.toInt();
                                                                                            quntity++;
                                                                                            int? newprice = price * quntity;
                                                                                            databaseHelper
                                                                                                .updateQuantityCartItems(
                                                                                              CartItem(
                                                                                                VariationTblId: snapshot.data![index].VariationTblId.toString(),
                                                                                                Color: snapshot.data![index].Color.toString(),
                                                                                                Size: snapshot.data![index].Size.toString(),
                                                                                                productId: snapshot.data![index].productId.toString(),
                                                                                                productDescription: snapshot.data![index].productDescription.toString(),
                                                                                                id: snapshot.data![index].id,
                                                                                                productName: snapshot.data![index].productName,
                                                                                                productPrice: newprice.toDouble(),
                                                                                                productQuantity: quntity,
                                                                                                productImage: snapshot.data![index].productImage.toString(),
                                                                                                initialPrice: snapshot.data![index].initialPrice,
                                                                                              ),
                                                                                            )
                                                                                                .then((value) {
                                                                                              pricetag = newprice;
                                                                                              print(pricetag);
                                                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                                            }).onError((error, stackTrace) {
                                                                                              print(error.toString());
                                                                                            });
                                                                                            print("clik button");
                                                                                          },
                                                                                          child: Container(
                                                                                              height: 7.5.w,
                                                                                              width: 7.5.w,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                                color: Color(0xfff7941d),
                                                                                              ),
                                                                                              child: Icon(
                                                                                                Icons.add,
                                                                                                size: 20.sp,
                                                                                                color: Colors.white,
                                                                                              )),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 1.w,
                                                                                  ),
                                                                                  Text(
                                                                                    snapshot.data![index].initialPrice.toString(),
                                                                                    style: TextStyle(
                                                                                      fontSize: 15.sp,
                                                                                      fontFamily: 'task',
                                                                                      fontWeight: FontWeight.normal,
                                                                                      letterSpacing: 1,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                2.h,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                        Positioned(
                                                          left: 86.w,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .highlight_remove,
                                                              size: 20.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ), // Icon to open the menu
                                                            onPressed: () {
                                                              print(pricetag);
                                                              showBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Stack(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: Colors.white),
                                                                        height:
                                                                            23.h,
                                                                        width: double
                                                                            .infinity,
                                                                        // Customize the bottom sheet content here
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 5.w,
                                                                              vertical: 2.h),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Remove From Cart?",
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: 'task'),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                "Are You Sure to delete this product from Cart?",
                                                                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp, fontFamily: 'task'),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 2.h,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Container(
                                                                                        alignment: Alignment.center,
                                                                                        height: 5.h,
                                                                                        width: 35.w,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white70, border: Border.all(width: 0.5, color: Colors.grey)),
                                                                                        child: Text(
                                                                                          "Cancel",
                                                                                          style: TextStyle(fontSize: 13.sp, color: Colors.black, fontFamily: "task", fontWeight: FontWeight.bold),
                                                                                        )),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        cart.removeTotalPrice(pricetag == 0 ? snapshot.data![index].initialPrice!.toDouble() : pricetag.toDouble());
                                                                                      });
                                                                                      databaseHelper.delete(
                                                                                        int.parse(snapshot.data![index].id.toString()),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Container(
                                                                                        alignment: Alignment.center,
                                                                                        height: 5.h,
                                                                                        width: 35.w,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Color(0xfff7941d)),
                                                                                        child: Text(
                                                                                          "Remove",
                                                                                          style: TextStyle(fontSize: 13.sp, color: Colors.white, fontFamily: "task"),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              // Add more options as needed
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        right:
                                                                            1.w,
                                                                        child: IconButton(
                                                                            icon: Icon(
                                                                              Icons.highlight_remove,
                                                                              size: 25.sp,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            // Icon to open the menu
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            } // We set onPressed to null to disable the button
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }, // We set onPressed to null to disable the button
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Container(
                                              width: 93.w,
                                              height: 8.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Color(0xffffffff),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 3.w,
                                                    ),
                                                    child: Text(
                                                      'Sub Total Amount',
                                                      style: TextStyle(
                                                        fontFamily: 'task',
                                                        color: Colors
                                                            .grey.shade800,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 3.w,
                                                    ),
                                                    child: Text(
                                                      '₹ ${cart.getTOtalPrice().toString()}',
                                                      // '₹ ' +
                                                      //     '${snapshot.data![0].productQuantity == 1 ? snapshot.data![0].productPrice.toString() : newprice.toString()}',
                                                      style: TextStyle(
                                                        fontFamily: 'task',
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3.h,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage2()));
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 7.w, left: 7.w),
                                                  alignment: Alignment.center,
                                                  height: 6.h,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Color(0xfff7941d)),
                                                  child: Text(
                                                    "Login to Checkout",
                                                    style: TextStyle(
                                                        fontSize: 17.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "task"),
                                                  )),
                                            ),
                                          ],
                                        ),
                                ],
                              );
                            }
                            return Text('helloo');
                          },
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _scaffoldKeycart.currentState
                                          ?.openDrawer();
                                    },
                                    icon: Icon(
                                      Icons.menu_rounded,
                                      size: 25.sp,
                                    )),
                                Text(
                                  "My Cart",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: "task",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage()));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        height: 12.2.w,
                                        width: 12.2.w,
                                        padding: EdgeInsets.all(1.w),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: profilemodal
                                                      ?.profileDetails
                                                      ?.profileimage ??
                                                  '',
                                              progressIndicatorBuilder: (context,
                                                      url, progress) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Icon(Icons
                                                      .error_outline_rounded)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          viewcartmodal?.cartDetails?.length == 0 ||
                                  viewcartmodal?.cartDetails?.length == null
                              ? Container(
                                  height: 80.h,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Data Available",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'task',
                                      fontSize: 20.sp,
                                    ),
                                  ))
                              : Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 65.5.h,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: viewcartmodal
                                              ?.cartDetails?.length,
                                          // The number of items in the grid
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            // Build each item in the grid
                                            return Stack(
                                              children: [
                                                Card(
                                                    color: Colors.white,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: (viewcartmodal
                                                                          ?.cartDetails?[
                                                                              index]
                                                                          .allImages)
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 34.w,
                                                                  width: 32.w,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        // fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 3.w,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0.5.h,
                                                                      horizontal:
                                                                          0.5.w),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        1.5.h,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 1.w),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              45.w,
                                                                          child:
                                                                              Text(
                                                                            (viewcartmodal?.cartDetails?[index].productName) == null
                                                                                ? "N/A"
                                                                                : (viewcartmodal?.cartDetails?[index].productName).toString(),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "task"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            1.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                27.w,
                                                                            height:
                                                                                6.5.h,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    int.parse(viewcartmodal?.cartDetails?[index].cartProductQuantity ?? '') <= 1 ? buildErrorDialog(context, 'Alert', 'Minimum allowed quantity is 1') : decrement((viewcartmodal?.cartDetails?[index].cartTblId).toString());
                                                                                    // setState(() {
                                                                                    //   age--;
                                                                                    // });
                                                                                  },
                                                                                  child: Container(
                                                                                      height: 7.5.w,
                                                                                      width: 7.5.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                        color: Color(0xfff7941d),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        Icons.remove,
                                                                                        size: 20.sp,
                                                                                        color: Colors.white,
                                                                                      )),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 2.5.w,
                                                                                ),
                                                                                Container(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        child: Text(
                                                                                          viewcartmodal?.cartDetails?[index].cartProductQuantity == null ? "1" : (viewcartmodal?.cartDetails?[index].cartProductQuantity).toString(),
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontFamily: "task",
                                                                                            fontSize: 16.sp,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 2.5.w,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    int.parse(viewcartmodal?.cartDetails?[index].cartProductQuantity ?? '') >= 5
                                                                                        ? buildErrorDialog(context, 'Alert', 'Maximum allowed quantity is 5')
                                                                                        : increment(
                                                                                            (viewcartmodal?.cartDetails?[index].cartTblId).toString(),
                                                                                          );
                                                                                  },
                                                                                  child: Container(
                                                                                      height: 7.5.w,
                                                                                      width: 7.5.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                        color: Color(0xfff7941d),
                                                                                      ),
                                                                                      child: Icon(
                                                                                        Icons.add,
                                                                                        size: 20.sp,
                                                                                        color: Colors.white,
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                1.w,
                                                                          ),
                                                                          Text(
                                                                            (viewcartmodal?.cartDetails?[index].productPriceMain) == null
                                                                                ? "N/A"
                                                                                : '₹' + (viewcartmodal?.cartDetails?[index].productPriceMain).toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.sp,
                                                                              fontFamily: 'task',
                                                                              fontWeight: FontWeight.normal,
                                                                              letterSpacing: 1,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 2.h,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Positioned(
                                                  left: 82.w,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.highlight_remove,
                                                      size: 20.sp,
                                                      color: Colors.grey,
                                                    ), // Icon to open the menu
                                                    onPressed: () {
                                                      showBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .white),
                                                                height: 23.h,
                                                                width: double
                                                                    .infinity,
                                                                // Customize the bottom sheet content here
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          2.h),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "Remove From Cart?",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15.sp,
                                                                                fontFamily: 'task'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        "Are You Sure to delete this product from Cart?",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            fontSize: 14.sp,
                                                                            fontFamily: 'task'),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                height: 5.h,
                                                                                width: 35.w,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white70, border: Border.all(width: 0.5, color: Colors.grey)),
                                                                                child: Text(
                                                                                  "Cancel",
                                                                                  style: TextStyle(fontSize: 13.sp, color: Colors.black, fontFamily: "task", fontWeight: FontWeight.bold),
                                                                                )),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              removecart((viewcartmodal?.cartDetails?[index].productID).toString());
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                height: 5.h,
                                                                                width: 35.w,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Color(0xfff7941d)),
                                                                                child: Text(
                                                                                  "Remove",
                                                                                  style: TextStyle(fontSize: 13.sp, color: Colors.white, fontFamily: "task"),
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      // Add more options as needed
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 1.w,
                                                                child: IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .highlight_remove,
                                                                      size:
                                                                          25.sp,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    // Icon to open the menu
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    } // We set onPressed to null to disable the button
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }, // We set onPressed to null to disable the button
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        width: 93.w,
                                        height: 7.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Color(0xffffffff),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 3.w,
                                              ),
                                              child: Text(
                                                'Sub Total Amount : ',
                                                style: TextStyle(
                                                  fontFamily: 'task',
                                                  fontSize: 15.sp,
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 3.w,
                                              ),
                                              child: Text(
                                                (viewcartmodal
                                                            ?.finalTotalWithTax) ==
                                                        null
                                                    ? "N/A"
                                                    : '₹' +
                                                        (viewcartmodal
                                                                ?.finalTotal)
                                                            .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'task',
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckoutDetail(
                                                        addid: alluseraddmodal
                                                            ?.allShippingAddress?[
                                                                0]
                                                            .id,
                                                        firstname: alluseraddmodal
                                                            ?.allShippingAddress?[
                                                                0]
                                                            .firstName,
                                                        lastname: alluseraddmodal
                                                            ?.allShippingAddress?[
                                                                0]
                                                            .lastName,
                                                        address: alluseraddmodal
                                                            ?.allShippingAddress?[
                                                                0]
                                                            .address,
                                                      )));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: 7.w, left: 7.w),
                                            alignment: Alignment.center,
                                            height: 6.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Color(0xfff7941d)),
                                            child: Text(
                                              "Checkout",
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "task"),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
              ),
      ),
    );
  }

  ViewCartApi() async {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().viewcartapi(data).then((response) async {
          viewcartmodal = ViewCartModal.fromJson(json.decode(response.body));
          print(viewcartmodal?.status);
          if (response.statusCode == 200 &&
              viewcartmodal?.status == "success") {
            print('EE Thay Gyu Hooooo ! ^_^');
            print(viewcartmodal?.finalTotalWithTax);
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  removecart(String value) async {
    final Map<String, String> data = {};
    data['user_id'] = (usermodal?.userId).toString();
    data['product_id'] = value.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().removecartapi(data).then((response) async {
          removecartmodal =
              RemoveCartModal.fromJson(json.decode(response.body));
          print(removecartmodal?.status);
          if (response.statusCode == 200 &&
              removecartmodal?.status == "success") {
            ViewCartApi();
            print('mer');
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  increment(String value) async {
    final Map<String, String> data = {};
    data['user_id'] = (usermodal?.userId).toString();
    data['cart_tbl_id'] = value.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().incrementapi(data).then((response) async {
          incrementmodal = IncrementModal.fromJson(json.decode(response.body));
          print(incrementmodal?.status);
          if (response.statusCode == 200 &&
              incrementmodal?.status == "success") {
            ViewCartApi();
            print('ADDD');
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  decrement(String value) async {
    final Map<String, String> data = {};
    data['user_id'] = (usermodal?.userId).toString();
    data['cart_tbl_id'] = value.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().disincrementapi(data).then((response) async {
          disincrementmodal =
              DisIncrementModal.fromJson(json.decode(response.body));
          print(disincrementmodal?.status);
          if (response.statusCode == 200 &&
              disincrementmodal?.status == "success") {
            ViewCartApi();

            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  viewap() {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().ViewProfile(data).then((response) async {
          profilemodal = ProfileModal.fromJson(json.decode(response.body));
          if (response.statusCode == 200 && profilemodal?.status == "success") {
            print(profilemodal?.status);
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  alluseraddapi() async {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().userallshippingapi(data).then((response) async {
          alluseraddmodal =
              AllUserAddModal.fromJson(json.decode(response.body));
          print(alluseraddmodal?.status);
          if (response.statusCode == 200 &&
              alluseraddmodal?.status == "success") {
            print(
                '====- Add : ${alluseraddmodal?.allShippingAddress?[0].address}');
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }
}
