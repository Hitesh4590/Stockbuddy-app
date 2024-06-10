import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_details_provider.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen({
    super.key,
    required this.skuNo,
    required this.title,
    required this.type,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.description,
    required this.images,
    required this.supplierName,
    required this.quantity,
  });
  final String skuNo;
  final String title;
  final String type;
  final double sellingPrice;
  final double purchasePrice;
  final String description;
  final List<String> images;
  final String supplierName;
  final int quantity;

  @override
  State<InventoryDetailsScreen> createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryDetailsProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Inventory Details',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
        actions: [
          GestureDetector(
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ).allp(5),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 230.0,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      provider.changePhoto(index);
                    },
                  ),
                  items: List.generate(widget.images.length, (i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                            '${widget.images[i]}',
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    );
                  }),
                ),
                Positioned(
                    top: 10,
                    right: 0,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    width: 1, color: Color(0xffEEEEEE))),
                            child:
                                SvgPicture.asset(ImageConstants.edit).allp(2),
                          ),
                          onTap: () {},
                        ),
                        10.vs,
                        GestureDetector(
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    width: 1, color: Color(0xffEEEEEE))),
                            child:
                                SvgPicture.asset(ImageConstants.trash).allp(2),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ))
              ],
            ),
            20.vs,
            SizedBox(
              height: 38, // Adjust the height as needed
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      decoration: index == provider.selectedIndex
                          ? BoxDecoration(
                              border: Border.all(
                                  width: 1, color: ColorConstants.lightGrey),
                              borderRadius: BorderRadius.circular(5))
                          : BoxDecoration(),
                      height: 38,
                      width: 38,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        widget.images[index],
                      ),
                    ),
                    onTap: () async {
                      await provider.changePhoto(index);
                      _controller.animateToPage(provider.selectedIndex);
                    },
                  );
                },
              ),
            ),
            20.vs,
            Text(
              'SKU NO:${widget.skuNo}',
              style: TextStyles.regularBlack(),
            ),
            20.vs,
            Text(
              widget.title,
              style: TextStyles.bold(fontSize: 18),
            ),
            20.vs,
            Row(
              children: [
                Text(
                  'Qty: ${widget.quantity}',
                  style: TextStyles.regularBlack(),
                ),
                10.hs,
                Container(
                  height: 15,
                  width: 1,
                  color: Colors.black,
                ),
                10.hs,
                Text(
                  'Type: ${widget.type}',
                  style: TextStyles.regularBlack(),
                ),
              ],
            ),
            20.vs,
            Row(
              children: [
                Text(
                  'Selling Price',
                  style: TextStyles.regular(),
                ),
                5.hs,
                Text(
                  widget.sellingPrice.toString(),
                  style: TextStyles.regularBlack(),
                ),
                Spacer(),
                Text(
                  'Purchase Price',
                  style: TextStyles.regular(),
                ),
                5.hs,
                Text(
                  widget.purchasePrice.toString(),
                  style: TextStyles.regularBlack(),
                )
              ],
            ),
            20.vs,
            RichText(
              text: TextSpan(
                text: 'Supplier Name ',
                style: TextStyles.regularBlack(),
                children: <TextSpan>[
                  TextSpan(text: widget.supplierName, style: TextStyles.bold()),
                ],
              ),
            ),
            20.vs,
            Text(
              'Description',
              style: TextStyles.regularBlack(),
            ),
            20.vs,
            Column(
              children: [
                Text(
                  widget.description,
                  style: TextStyles.regularBlack(),
                ),
              ],
            )
          ],
        ).allp(20),
      ),
    );
  }
}
