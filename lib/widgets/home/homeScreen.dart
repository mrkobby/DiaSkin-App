import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300],
              ),
            ),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 26.0, left: 16.0),
                child: Text(
                  "Hi, Kwabena Aboagye",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 16.0),
                child: Text("Sunday, Dec 15"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 21,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("UPCOMMING APPOINTMENTS"),
                ),
                Container(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      AppointmentCard(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("MESSAGES"),
                ),
                SizedBox(
                  height: 9,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      MessagesCard(
                        color: Colors.purple,
                        icon: Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(11.0),
      padding: EdgeInsets.all(15.0),
      width: 250,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Consulting Doctor"),
          SizedBox(
            height: 21,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "http://pngimg.com/uploads/doctor/doctor_PNG15957.png",
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr. Tobias Parker",
                      style: TextStyle(fontSize: 23, color: Color(0xFF1C0942)),
                    ),
                    Text(
                      "Watz Clinic",
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Tommorow",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                "03:30PM",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessagesCard extends StatelessWidget {
  final Color color;
  final Icon icon;
  const MessagesCard({Key key, this.color, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey[300], blurRadius: 3.0, offset: Offset(0, 1))
      ]),
      margin: EdgeInsets.symmetric(vertical: 11.0, horizontal: 5.0),
      padding: EdgeInsets.all(11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: icon,
          ),
          SizedBox(
            width: 21,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Acne",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Spacer(),
                    Text("10:00"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 240,
                      child: Text(
                        "Commonly located on the face, neck, shoulders, chest, and upper back. Breakouts on the skin" +
                            "composed of blackheads, whiteheads, pimples, or deep, painful cysts and nodules",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
