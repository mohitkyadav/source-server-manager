import 'package:flutter/material.dart';

class HomeForm extends StatefulWidget {

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(child: Text('Input form')),
            const SizedBox(height: 20,),
            TextFormField(
              validator: (val)  => val.isEmpty ? 'Required field' : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter Name',
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              validator: (val)  => val.isEmpty ? 'Required field' : null,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 20),
                    lastDate: DateTime.now(),
                );
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of birth',
                hintText: 'Enter DOB',
              ),
            ),
            const SizedBox(height: 20,),
            MaterialButton(
              onPressed: () {
                if (_key.currentState.validate()) {
                  print('successfully validated form');
                }
              },
              height: 60,
              shape: StadiumBorder(),
              color: Theme.of(context).accentColor,
              child: Text('Submit form data'),
            ),
          ],
        ),
      ),
    );
  }
}
