import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockbuddy_flutter_app/common/extension.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import 'package:stockbuddy_flutter_app/common/theme/text_styles.dart';
import 'package:stockbuddy_flutter_app/common/widget/app_textfield.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';
import 'package:stockbuddy_flutter_app/providers/edit_sku_provider.dart';

import '../common/widget/app_button.dart';

class EditSkuScreen extends StatefulWidget {
  const EditSkuScreen({
    Key? key,
    required this.detail,
  }) : super(key: key);

  final ProductDetail detail;

  @override
  _EditSkuScreenState createState() => _EditSkuScreenState();
}

class _EditSkuScreenState extends State<EditSkuScreen> {
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<EditSkuProvider>(context, listen: false)
        .fetchImages(widget.detail);
    descriptionController.text = widget.detail.description;
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<EditSkuProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 16,
          onPressed: () {
            provider.clearImages();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Edit ${widget.detail.sku}',
          style: TextStyles.regularBlack(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.vs,
            Text(
              'Images',
              style: TextStyles.medium(),
            ),
            10.vs,
            Row(
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => provider.pickImage(index),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                        image: provider.imageUrls[index].isNotEmpty
                            ? NetworkImage(provider.imageUrls[index])
                            : const NetworkImage(
                                ImageConstants.backgroundImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).rp(16),
                );
              }),
            ),
            20.vs,
            AppTextFormFields.multiline(
              minLines: 3,
              controller: descriptionController,
              hint: 'Description',
              label: 'Description',
            ),
            140.vs,
            AppButton(
              isLoading: provider.isLoading,
              labelText: 'Save',
              onTap: () async {
                provider.changeLoading(true);
                await provider.save(widget.detail, descriptionController.text);
                provider.changeLoading(false);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
