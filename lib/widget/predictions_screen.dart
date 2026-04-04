import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/model/search_place_model.dart';

class PredictionItemWidget extends StatefulWidget {
  const PredictionItemWidget({super.key});

  @override
  State<PredictionItemWidget> createState() => _PredictionItemWidgetState();
}

class _PredictionItemWidgetState extends State<PredictionItemWidget> {
  @override
  Widget build(BuildContext context) {
    final searchProvder = Provider.of<SearchPlaceModel>(context, listen: false);
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: Icon(Icons.timer_outlined, color: Colors.blueAccent),
        title: Text(
          searchProvder.mainText ?? 'UnKnown',
          softWrap: true,
          style: TextStyle(fontSize: 18, fontFamily: 'Brand-Regular'),
        ),
        subtitle: Text(searchProvder.secondaryText ?? 'No Address Avaliable'),
      ),
    );
  }
}
