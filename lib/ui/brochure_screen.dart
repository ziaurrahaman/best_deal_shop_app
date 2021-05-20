import 'package:best_deal_shop_app/models/brochures_model.dart';
import 'package:best_deal_shop_app/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class BrochureScreen extends StatelessWidget {
  final BrochuresModel brochuresModel;

  const BrochureScreen({Key key, @required this.brochuresModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PDF.network(
          '${brochuresModel.pdf}',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          placeHolder: Center(child: LoadingWidget()),
        ),
      ),
    );
  }
}
