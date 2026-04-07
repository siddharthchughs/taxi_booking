import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_booking/model/search_place_model.dart';

class PredictionItemWidget extends StatefulWidget {
  const PredictionItemWidget({super.key, required this.onDestinationSelected});
  final Function(SearchPlaceModel searchPlace) onDestinationSelected;

  @override
  State<PredictionItemWidget> createState() => _PredictionItemWidgetState();
}

class _PredictionItemWidgetState extends State<PredictionItemWidget> {
  bool isLocationEnabled = false;

  @override
  Widget build(BuildContext context) {
    final searchProvder = Provider.of<SearchPlaceModel>(context, listen: true);
    return ListTile(
      onTap: () => widget.onDestinationSelected(searchProvder),
      leading: Icon(Icons.timer_outlined, color: Colors.blueAccent),
      title: Text(
        searchProvder.mainText ?? 'UnKnown',
        softWrap: true,
        style: TextStyle(fontSize: 18, fontFamily: 'Brand-Regular'),
      ),
      subtitle: Text(searchProvder.secondaryText ?? 'No Address Avaliable'),
    );
  }
}
