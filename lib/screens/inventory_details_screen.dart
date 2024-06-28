import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';
import 'package:stockbuddy_flutter_app/providers/inventory_details_provider.dart';
import 'package:stockbuddy_flutter_app/screens/dash_board_screen.dart';
import 'package:stockbuddy_flutter_app/screens/edit_batch_screen.dart';
import '../common/theme/color_constants.dart';
import '../common/theme/text_styles.dart';
import '../providers/toggle_provider.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen(
      {super.key, required this.detail, required this.batch});
  final ProductDetail detail;
  final ProductBatch batch;

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
        leading: IconButton(
            iconSize: 16,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          'Inventory Details',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
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
                  items: List.generate(widget.detail.photos.length, (i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.network(
                            widget.detail.photos[i],
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditBatchScreen(
                                        detail: widget.detail,
                                        batch: widget.batch)));
                          },
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
                          onTap: () async {
                            if (widget.batch.quantity ==
                                widget.batch.available) {
                              await provider.delete(
                                  widget.detail, widget.batch);
                              ToggleProvider().changeScreen(2);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoardScreen()),
                                (Route<dynamic> route) =>
                                    false, // This removes all the previous routes
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Cannot delete, items are sold from this batch'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
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
                itemCount: widget.detail.photos.length,
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
                        widget.detail.photos[index],
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
              'SKU NO:${widget.detail.sku}',
              style: TextStyles.regularBlack(),
            ),
            20.vs,
            Text(
              widget.detail.title,
              style: TextStyles.bold(fontSize: 18),
            ),
            20.vs,
            Row(
              children: [
                Text(
                  'Qty: ${widget.batch.available}',
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
                  'Type: ${widget.detail.type}',
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
                  widget.batch.sellPrice.toString(),
                  style: TextStyles.regularBlack(),
                ),
                const Spacer(),
                Text(
                  'Purchase Price',
                  style: TextStyles.regular(),
                ),
                5.hs,
                Text(
                  widget.batch.buyPrice.toString(),
                  style: TextStyles.regularBlack(),
                )
              ],
            ),
            16.vs,
            const Text('Color'),
            10.vs,
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(widget.detail.color, radix: 16)),
              ),
            ),
            20.vs,
            RichText(
              text: TextSpan(
                text: 'Supplier Name ',
                style: TextStyles.regularBlack(),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.batch.supplierName,
                      style: TextStyles.bold()),
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
                  widget.detail.description,
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
