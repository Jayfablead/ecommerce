import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/Databasehandler.dart';
import 'package:ecommerce/Modal/AddCartModal.dart';
import 'package:ecommerce/Modal/AddToWishLIstModal.dart';
import 'package:ecommerce/Modal/Cartmodal.dart';
import 'package:ecommerce/Modal/ColorMatchModal.dart';
import 'package:ecommerce/Modal/ColorShowModal.dart';
import 'package:ecommerce/Modal/ProductDetailModal.dart';
import 'package:ecommerce/Modal/ProfileModal.dart';
import 'package:ecommerce/Modal/RemoveWishListModal.dart';
import 'package:ecommerce/Modal/SelectColorModal.dart';
import 'package:ecommerce/Modal/SizeShowModal.dart';
import 'package:ecommerce/Provider/Authprovider.dart';
import 'package:ecommerce/Screen/LoginPage2.dart';
import 'package:ecommerce/Screen/ProfilePage.dart';
import 'package:ecommerce/Widget/Const.dart';
import 'package:ecommerce/Widget/Drawer.dart';
import 'package:ecommerce/Widget/buildErrorDialog.dart';
import 'package:ecommerce/Widget/loder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Provider/cartProvider.dart';
import '../Widget/bottombar.dart';

class ProductDetailPage2 extends StatefulWidget {
  String? productid;

  ProductDetailPage2({
    super.key,
    this.productid,
  });

  @override
  State<ProductDetailPage2> createState() => _ProductDetailPage2State();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

int sel = 1;
int color = 0;

bool isLoading = true;

final controller = PageController(viewportFraction: 0.8, keepPage: true);
List pages = [];
bool h = false;
List sizername = ['XS', 'S', 'M', 'XL', 'L'];

List<Color> colorList = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
];

DatabaseHelper databaseHelper = DatabaseHelper();

int selectedColorIndex = 0;

int selcted = 0;
String? price;
String? price1;

class _ProductDetailPage2State extends State<ProductDetailPage2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      color = 0;
      selected = 0;
      isLoading = true;
    });
    productdetailap();
    colorap();
    sizeap();
    colorshowmodal?.variationData?.length != 0 &&
            sizeshowmodal?.variationData?.length != 0
        ? colormatchap()
        : selectcolorap();
  }

  @override
  Widget build(BuildContext context) {
    final cartitm = Provider.of<CartProvider>(context);
    addoff() async {
      print("notlog");
      CartItem item = CartItem(
        VariationTblId: colormatchmodal?.priceData?.length == 0 ||
                colorshowmodal?.variationData?.length == 0 &&
                    sizeshowmodal?.variationData?.length == 0
            ? '0'
            : colormatchmodal?.priceData?[0].variationMatchId ?? "",
        productId: widget.productid.toString(),
        Size: sizeshowmodal?.variationData?.length == 0
            ? "0"
            : sizeshowmodal?.variationData?[selcted].variationID ?? '',
        Color: colorshowmodal?.variationData?.length == 0
            ? '0'
            : (colorshowmodal?.variationData?[0].variationID ?? ""),
        initialPrice: sizeshowmodal?.variationData?.length != 0
            ? double.parse(price.toString())
            : colorshowmodal?.variationData?.length == 0 &&
                    sizeshowmodal?.variationData?.length == 0
                ? double.parse(
                    (productdetailmodal?.productData?.saleProductPrice)
                        .toString())
                : double.parse(
                    (selectcolormodal?.variationData?.saleVariationPrice)
                        .toString()),
        productName: productdetailmodal?.productData?.productName ?? "",
        productQuantity: 1,
        productImage: productdetailmodal?.productData?.allimage?[0] ?? "",
        productPrice: sizeshowmodal?.variationData?.length != 0
            ? double.parse(price.toString())
            : colorshowmodal?.variationData?.length == 0 &&
                    sizeshowmodal?.variationData?.length == 0
                ? double.parse(
                    (productdetailmodal?.productData?.saleProductPrice)
                        .toString())
                : double.parse(
                    (selectcolormodal?.variationData?.saleVariationPrice)
                        .toString()),
        productDescription:
            productdetailmodal?.productData?.productShortDesc ?? "",
      );
      int result = await databaseHelper.insertCartItem(item);
      if (result != 0) {
        cartitm.addTotalPrice(sizeshowmodal?.variationData?.length != 0
            ? double.parse(price.toString())
            : colorshowmodal?.variationData?.length == 0 &&
                    sizeshowmodal?.variationData?.length == 0
                ? double.parse(
                    (productdetailmodal?.productData?.saleProductPrice)
                        .toString())
                : double.parse(
                    (selectcolormodal?.variationData?.saleVariationPrice)
                        .toString()));

        buildErrorDialog(context, '', 'Your item is Added in Cart');

      }
    }

    return commanScreen(
      isLoading: isLoading,
      scaffold: Scaffold(
        key: _scaffoldKey,
        drawer: drawer1(),
        bottomNavigationBar: bottombar(),
        body: isLoading
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 25.sp,
                                )),
                            Text(
                              "Product Detail Page",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: "task",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    usermodal?.userId == "" ||
                                            usermodal?.userId == null
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage2()))
                                        : Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage()));
                                  },
                                  child: usermodal?.userId == "" ||
                                          usermodal?.userId == null
                                      ? Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Color(0xfff7941d),
                                            fontFamily: 'task',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.sp,
                                          ),
                                        )
                                      : Container(
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
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                            'assets/deim.png')),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 2.h),
                                    SizedBox(
                                      height: 230,
                                      child: PageView.builder(
                                        controller: controller,
                                        itemCount: pages.length,
                                        itemBuilder: (_, index) {
                                          return pages[index % pages.length];
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SmoothPageIndicator(
                                      controller: controller,
                                      count: pages.length,
                                      effect: WormEffect(
                                        dotColor: Colors.grey.shade100,
                                        activeDotColor: Color(0xfff7941d),
                                        dotHeight: 1.5.h,
                                        dotWidth: 4.w,
                                        type: WormType.thinUnderground,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w, vertical: 2.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 57.w,
                                            child: Text(
                                              productdetailmodal?.productData
                                                              ?.productName ==
                                                          '' ||
                                                      productdetailmodal
                                                              ?.productData
                                                              ?.productName ==
                                                          null
                                                  ? 'N/A'
                                                  : productdetailmodal
                                                          ?.productData
                                                          ?.productName ??
                                                      '',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "task",
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              usermodal?.userId == "" ||
                                                      usermodal?.userId == null
                                                  ? Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage2()))
                                                  : productdetailmodal
                                                              ?.productData
                                                              ?.wishlist ==
                                                          1
                                                      ? removewishlistap(
                                                          (productdetailmodal
                                                                  ?.productData
                                                                  ?.productID)
                                                              .toString())
                                                      : addwishlistap(
                                                          (productdetailmodal
                                                                  ?.productData
                                                                  ?.productID)
                                                              .toString());
                                            },
                                            child: Icon(
                                              productdetailmodal?.productData
                                                          ?.wishlist ==
                                                      1
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              size: 25.sp,
                                              color: productdetailmodal
                                                          ?.productData
                                                          ?.wishlist ==
                                                      1
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 0.7.h,
                                      ),
                                      ReadMoreText(
                                        productdetailmodal?.productData
                                                        ?.productShortDesc ==
                                                    '' ||
                                                productdetailmodal?.productData
                                                        ?.productShortDesc ==
                                                    null
                                            ? 'N/A'
                                            : productdetailmodal?.productData
                                                    ?.productShortDesc ??
                                                '',
                                        trimLines: 2,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontFamily: "task"),
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        lessStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'task',
                                            color: Color(
                                              0xfff7941d,
                                            ),
                                            fontSize: 12.sp),
                                        moreStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'task',
                                            color: Color(0xfff7941d),
                                            fontSize: 12.sp),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      colorshowmodal?.variationData?.length ==
                                                  0 ||
                                              colorshowmodal
                                                      ?.variationData?.length ==
                                                  null
                                          ? Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: 'task',
                                                  fontSize: 15.sp,
                                                  color: Colors.black),
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 7.h,
                                                  child: Center(
                                                    child: Text(
                                                      "Color :",
                                                      style: TextStyle(
                                                          fontFamily: 'task',
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                SizedBox(
                                                  height: 6.h,
                                                  width: 70.w,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding: EdgeInsets.zero,
                                                      itemCount: colorshowmodal
                                                          ?.variationData
                                                          ?.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Stack(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  color = index;
                                                                });
                                                                colorshowmodal?.variationData?.length !=
                                                                            0 &&
                                                                        sizeshowmodal?.variationData?.length !=
                                                                            0
                                                                    ? colormatchap()
                                                                    : selectcolorap();
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            1.w),
                                                                height: 13.w,
                                                                width: 13.w,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(1
                                                                            .w),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              90),
                                                                  child: CachedNetworkImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      imageUrl:
                                                                          colorshowmodal?.variationData?[index].varImg ??
                                                                              '',
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              progress) =>
                                                                          CircularProgressIndicator(),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image.asset(
                                                                              'assets/deim.png')),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          1.w),
                                                              height: 13.w,
                                                              width: 13.w,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1.w),
                                                              child: color ==
                                                                      index
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          20.sp,
                                                                    )
                                                                  : Icon(null),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      sizeshowmodal?.variationData?.length ==
                                                  0 ||
                                              colorshowmodal
                                                      ?.variationData?.length ==
                                                  null
                                          ? Container(
                                              //-------***** Price and add cart button hight-------------********
                                              // height: 15.5.h
                                              )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 7.h,
                                                  child: Center(
                                                    child: Text(
                                                      "Size :",
                                                      style: TextStyle(
                                                          fontFamily: 'task',
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                SizedBox(
                                                  height: 12.h,
                                                  width: 70.w,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding: EdgeInsets.zero,
                                                      itemCount: sizeshowmodal
                                                          ?.variationData
                                                          ?.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  selcted =
                                                                      index;
                                                                });

                                                                colorshowmodal?.variationData?.length !=
                                                                            0 &&
                                                                        sizeshowmodal?.variationData?.length !=
                                                                            0
                                                                    ? colormatchap()
                                                                    : selectcolorap();
                                                              },
                                                              child: Container(
                                                                height: 11.w,
                                                                width: 11.w,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            0.5,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade100),
                                                                    color: selcted ==
                                                                            index
                                                                        ? Color(
                                                                            0xfff7941d)
                                                                        : Colors
                                                                            .grey
                                                                            .shade100,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            2.w),
                                                                child: Center(
                                                                  child: Text(
                                                                      sizeshowmodal?.variationData?[index].variationName ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          fontSize: 12.5
                                                                              .sp,
                                                                          color: selcted == index
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                          fontFamily:
                                                                              'task',
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          letterSpacing:
                                                                              1)),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 0.5.h,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.h),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 3.w,
                            bottom: 0.0,
                            child: Row(
                              children: [
                                Container(
                                  height: 6.h,
                                  width: 45.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            colorshowmodal?.variationData
                                                            ?.length !=
                                                        0 &&
                                                    sizeshowmodal?.variationData
                                                            ?.length !=
                                                        0
                                                ? colormatchmodal?.priceData
                                                            ?.length ==
                                                        0
                                                    ? 'Out of stock'
                                                    : '₹${(colormatchmodal?.priceData?[0].saleVariationPrice ?? '')}'
                                                : colorshowmodal?.variationData
                                                                ?.length ==
                                                            0 &&
                                                        sizeshowmodal
                                                                ?.variationData
                                                                ?.length ==
                                                            0
                                                    ? productdetailmodal
                                                                    ?.productData
                                                                    ?.saleProductPrice ==
                                                                '' ||
                                                            productdetailmodal
                                                                    ?.productData
                                                                    ?.saleProductPrice ==
                                                                null
                                                        ? "N/A"
                                                        : '₹${productdetailmodal?.productData?.saleProductPrice ?? ''}'
                                                    : selectcolormodal
                                                                    ?.variationData
                                                                    ?.saleVariationPrice ==
                                                                '' ||
                                                            selectcolormodal
                                                                    ?.variationData
                                                                    ?.saleVariationPrice ==
                                                                null
                                                        ? 'N/A'
                                                        : "₹${selectcolormodal?.variationData?.saleVariationPrice ?? ''}",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontFamily: 'task',
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.5.w,
                                          ),

                                          //--------*******SALES PRICE********------
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 0.4.h),
                                            child: Text(
                                              colorshowmodal?.variationData
                                                              ?.length !=
                                                          0 &&
                                                      sizeshowmodal
                                                              ?.variationData
                                                              ?.length !=
                                                          0
                                                  ? colormatchmodal?.priceData
                                                              ?.length ==
                                                          0
                                                      ? ''
                                                      : '₹${(colormatchmodal?.priceData?[0].variationPrice ?? '')}'
                                                  : colorshowmodal?.variationData
                                                                  ?.length ==
                                                              0 &&
                                                          sizeshowmodal
                                                                  ?.variationData
                                                                  ?.length ==
                                                              0
                                                      ? productdetailmodal
                                                                      ?.productData
                                                                      ?.productPrice ==
                                                                  '' ||
                                                              productdetailmodal
                                                                      ?.productData
                                                                      ?.productPrice ==
                                                                  null
                                                          ? ''
                                                          : '₹${productdetailmodal?.productData?.productPrice ?? ''}'
                                                      : selectcolormodal
                                                                      ?.variationData
                                                                      ?.variationPrice ==
                                                                  '' ||
                                                              selectcolormodal
                                                                      ?.variationData
                                                                      ?.variationPrice ==
                                                                  null
                                                          ? ''
                                                          : "₹${selectcolormodal?.variationData?.variationPrice ?? ''}",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationThickness: 2,
                                                decorationColor: Colors.black,
                                                fontSize: 12.sp,
                                                fontFamily: 'task',
                                                fontWeight: FontWeight.normal,
                                                letterSpacing: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                colormatchmodal?.priceData?.length == 0 &&
                                        sizeshowmodal?.variationData?.length !=
                                            0
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          print(usermodal?.userId);
                                          usermodal?.userId == "" ||
                                                  usermodal?.userId == null
                                              ? addoff()
                                              : addcartap();
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 6.h,
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color(0xfff7941d)),
                                                child: Text(
                                                  "Add To Cart",
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.white,
                                                      fontFamily: "task"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  productdetailap() async {
    final Map<String, String> data = {};
    data['product_id'] = widget.productid.toString();
    data['user_id'] = (usermodal?.userId).toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().productdetailapi(data).then((response) async {
          productdetailmodal =
              ProductDetailModal.fromJson(json.decode(response.body));
          print(productdetailmodal?.status);
          if (response.statusCode == 200 &&
              productdetailmodal?.status == "success") {
            colorap();
            sizeap();
            colorshowmodal?.variationData?.length != 0 &&
                    sizeshowmodal?.variationData?.length != 0
                ? colormatchap()
                : selectcolorap();
            pages = List.generate(
                (productdetailmodal?.productData?.allimage?.length ?? 0),
                (index) => Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 4),
                      child: Container(
                        height: 280,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: productdetailmodal
                                        ?.productData?.allimage?[index] ??
                                    '',
                                progressIndicatorBuilder:
                                    (context, url, progress) =>
                                        CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/deim.png')),
                          ),
                        ),
                      ),
                    ));
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
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  addwishlistap(String value) async {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    data['productID'] = value.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().addtowishlistapi(data).then((response) async {
          addtowishlIstmodal =
              AddToWishLIstModal.fromJson(json.decode(response.body));
          print(addtowishlIstmodal?.status);
          if (response.statusCode == 200 &&
              addtowishlIstmodal?.status == "success") {
            buildErrorDialog(context, '', "Your item is added in wishlist");
            productdetailap();

            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  removewishlistap(String value) {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    data['productID'] = value.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().removewishlistapi(data).then((response) async {
          removewishlistmodal =
              RemoveWishListModal.fromJson(json.decode(response.body));
          if (response.statusCode == 200 &&
              removewishlistmodal?.status == "success") {
            buildErrorDialog(context, '', "Your item is removed from wishlist");
            productdetailap();
            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  colorap() async {
    final Map<String, String> data = {};
    data['product_id'] = widget.productid.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().colorapi(data).then((response) async {
          colorshowmodal = ColorShowModal.fromJson(json.decode(response.body));
          if (response.statusCode == 200 &&
              colorshowmodal?.status == "success") {
            print("color");
            print(colorshowmodal?.variationData?.length);
            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  sizeap() async {
    final Map<String, String> data = {};
    data['product_id'] = widget.productid.toString();
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().sizeapi(data).then((response) async {
          sizeshowmodal = SizeShowModal.fromJson(json.decode(response.body));
          print(sizeshowmodal?.status);
          if (response.statusCode == 200 &&
              sizeshowmodal?.status == "success") {
            print("size");
            print(colorshowmodal?.variationData?.length);
            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  selectcolorap() async {
    final Map<String, String> data = {};
    data['variation_idd'] =
        colorshowmodal?.variationData?[color].variationIdd ?? '';
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().selectcolorapi(data).then((response) async {
          selectcolormodal =
              SelectColorModal.fromJson(json.decode(response.body));
          print(selectcolormodal?.status);
          if (response.statusCode == 200 &&
              selectcolormodal?.status == "success") {
            print(selectcolormodal?.variationData?.variationPrice);
            pages = List.generate(
                (selectcolormodal?.variationData?.allimage?.length ?? 0),
                (index) => Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 4),
                      child: Container(
                        height: 280,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl: selectcolormodal
                                        ?.variationData?.allimage?[index] ??
                                    '',
                                progressIndicatorBuilder:
                                    (context, url, progress) =>
                                        CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/deim.png')),
                          ),
                        ),
                      ),
                    ));
            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  colormatchap() async {
    final Map<String, String> data = {};
    data['product_id'] = widget.productid.toString();
    data['color_variation_id'] =
        colorshowmodal?.variationData?[color].variationID ?? "";
    data['size_variation_id'] =
        sizeshowmodal?.variationData?[selcted].variationID ?? '';
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().colormatchapi(data).then((response) async {
          colormatchmodal =
              ColorMatchModal.fromJson(json.decode(response.body));
          if (response.statusCode == 200 &&
              colormatchmodal?.status == "success") {
            print('aa batli data');
            print(colormatchmodal?.priceData?[0].saleVariationPrice ?? '');
            pages = colormatchmodal?.priceData?.length == 0
                ? List.generate(
                    1,
                    (index) => Container(
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 7.5.w, vertical: 4),
                          child: Container(
                            height: 280,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    imageUrl:
                                        'https://www.contentviewspro.com/wp-content/uploads/2017/07/default_image.png',
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset('assets/deim.png')),
                              ),
                            ),
                          ),
                        ))
                : List.generate(
                    (colormatchmodal?.priceData?[0].allimage?.length ?? 0),
                    (index) => Container(
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 7.5.w, vertical: 4),
                          child: Container(
                            height: 280,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                    imageUrl: colormatchmodal
                                            ?.priceData?[0].allimage?[index] ??
                                        '',
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset('assets/deim.png')),
                              ),
                            ),
                          ),
                        ));

            setState(() {
              price1 =
                  colormatchmodal?.priceData?[0].variationPrice?.toString();
              price =
                  colormatchmodal?.priceData?[0].saleVariationPrice?.toString();
              // isLoading = false;
            });
          } else {
            setState(() {
              price = "";
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });

        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }

  addcartap() async {
    final Map<String, String> data = {};
    data['userId'] = (usermodal?.userId).toString();
    data['productID'] = widget.productid.toString();
    data['variation_tbl_id'] = colormatchmodal?.priceData?.length == 0 ||
            colorshowmodal?.variationData?.length == 0 &&
                sizeshowmodal?.variationData?.length == 0
        ? '0'
        : colormatchmodal?.priceData?[0].variationMatchId ?? "";
    data['product_color'] = colorshowmodal?.variationData?.length == 0
        ? '0'
        : (colorshowmodal?.variationData?[0].variationID ?? "");
    data['product_size'] = sizeshowmodal?.variationData?.length == 0
        ? "0"
        : sizeshowmodal?.variationData?[selcted].variationID ?? '';
    data['product_quantity'] = '1';
    data['product_price'] = sizeshowmodal?.variationData?.length != 0
        ? price.toString()
        : colorshowmodal?.variationData?.length == 0 &&
                sizeshowmodal?.variationData?.length == 0
            ? (productdetailmodal?.productData?.saleProductPrice).toString()
            : (selectcolormodal?.variationData?.saleVariationPrice).toString();
    print('Add to Cart');
    print(data);
    checkInternet().then((internet) async {
      if (internet) {
        authprovider().addcartapi(data).then((response) async {
          addcartmodal = AddCartModal.fromJson(json.decode(response.body));
          print(addcartmodal?.status);
          if (response.statusCode == 200 && addcartmodal?.status == "success") {
            productdetailap();
            buildErrorDialog(context, '', "Your item is added in Cart");
            print('EE Thay Gyu Hooooo ! ^_^');
            setState(() {
              // isLoading = false;
            });
          } else {
            setState(() {
              // isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          // isLoading = false;
        });
        buildErrorDialog(context, 'Error', "Internet Required");
      }
    });
  }
}
