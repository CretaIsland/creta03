import 'package:creta_common/common/creta_font.dart';
import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/pages/studio/right_menu/property_mixin.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class GoogleMapSavedList extends StatefulWidget {
  final void Function(String address)? onAddressSelected;
  const GoogleMapSavedList({super.key, this.onAddressSelected});

  @override
  State<GoogleMapSavedList> createState() => _GoogleMapSavedListState();
}

class _GoogleMapSavedListState extends State<GoogleMapSavedList> with PropertyMixin {
  bool _isSavedListOpened = true;
  AddressManager addressProvider = AddressManager();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: addressProvider),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: propertyCard(
          isOpen: _isSavedListOpened,
          onPressed: () {
            setState(() {
              _isSavedListOpened = !_isSavedListOpened;
            });
          },
          titleWidget: Text(CretaStudioLang['googleMapSavedList']!, style: CretaFont.titleSmall),
          trailWidget: Text('', style: CretaFont.titleSmall),
          hasRemoveButton: false,
          onDelete: () {},
          bodyWidget: _googleMapProperties(),
        ),
      ),
    );
  }

  Widget _googleMapProperties() {
    return Container(
      padding: const EdgeInsets.only(top: 4.0),
      width: double.infinity,
      height: 350,
      color: Colors.blue[100],
      child: Consumer<AddressManager>(builder: (context, adddressManager, child) {
        return ListView.builder(
          itemCount: adddressManager.selectedAddress.length,
          itemBuilder: (context, index) {
            logger.fine('adddressManager.selectedAddress ${adddressManager.selectedAddress}');
            return ListTile(
              title: Text(
                adddressManager.selectedAddress.isNotEmpty
                    ? adddressManager.selectedAddress[index]
                    : '',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, size: 20.0),
                onPressed: () {
                  setState(() {});
                },
              ),
            );
          },
        );
      }),
    );
  }
}

class AddressManager extends ChangeNotifier {
  List<String> selectedAddress = [];
  void addAdress(String address) {
    selectedAddress.add(address);
    notifyListeners();
  }

  void removeAdress(String address) {
    selectedAddress.remove(address);
    notifyListeners();
  }
}
