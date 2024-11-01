import 'package:flutter/material.dart';
import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';

class CountrySelectionListTile extends StatelessWidget {
  const CountrySelectionListTile({
    super.key,
    required this.flagAsset,
    required this.countryName,
    required this.isCountrySelected,
    this.onTap,
  });

  final String flagAsset;
  final String countryName;
  final bool isCountrySelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        flagAsset,
      ),
      title: Text(
        countryName,
        style: context.theme.getTextStyle.bodyText1,
      ),
      trailing: Icon(
        isCountrySelected ? Icons.circle : Icons.circle_outlined,
      ),
      onTap: onTap,
    );
  }
}