import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/themes/styling.dart';

class EmptyServerState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: AppStyles.darkGray,
        child: Text(AppLocalizations.of(context)
            .getTranslatedValue('empty_sv_msg'), style: AppStyles.textH2,),
      ),
    );
  }
}
