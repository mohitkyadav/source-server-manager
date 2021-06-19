import 'package:flutter/material.dart';

import 'package:turrant/localization/app_localizations.dart';
import 'package:turrant/themes/styling.dart';

class EmptyServerState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20,),
            Image.asset('assets/img/turrant-no-players.png',
              width: 200,
            ),
            const SizedBox(height: 20,),
            Text(AppLocalizations.of(context)
                .getTranslatedValue('empty_sv_msg'), style: AppStyles.emptySvMsg,),
          ],
        ),
      ),
    );
  }
}
