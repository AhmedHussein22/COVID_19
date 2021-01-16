import 'package:covid_19/providers/theme.dart';
import 'package:covid_19/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);
  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases:
        EndpointCardData('Cases', 'assets/count.png', ),
    Endpoint.casesConfirmed:
        EndpointCardData('Confirmed ', 'assets/fever.png', ),
    Endpoint.deaths:
        EndpointCardData('Deaths', 'assets/death.png', ),
    Endpoint.recovered:
        EndpointCardData('Recovered', 'assets/patient.png', ),
    Endpoint.casesSuspected:
        EndpointCardData('Suspected ', 'assets/suspect.png', ),
  };
  @override
  Widget build(BuildContext context) {
    final double sizewidth = MediaQuery.of(context).size.width;
    final double sizeheight = MediaQuery.of(context).size.height;
     final themeprovider = Provider.of<DarkMode>(context);
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 5,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 4),
              Image.asset(
                cardData.assetName,
                color: Color(0xFFe60000),
                width: sizewidth * 0.25,
                height: sizeheight * 0.09,
              ),

              Text(
                cardData.title,
                textAlign: TextAlign.center,
                
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: themeprovider.isdark?Colors.white: Colors.black ,
                    fontFamily: "Exo2"
                    ),
              ),
              SizedBox(height: 4),
              Text(
                value != null ? "${value.toString()}" : "Loading...",
                style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Color(0xFF767676), fontWeight: FontWeight.w500,fontFamily: "Exo2"),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class EndpointCardData {
  EndpointCardData(this.title, this.assetName, );
  final String title;
  final String assetName;
  
}
