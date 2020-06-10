import 'package:flutter/material.dart';
import 'package:song_hub/services/db_service.dart';

class FilesGrid extends StatelessWidget {
  final String id;

  FilesGrid({@required this.id});
  // TODO: Implement records stream instead of single request to render new files too
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _db.getRecords(id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return new Container();
          }
          // Map content = snapchot.data;
          return GridView.builder(
              padding: EdgeInsets.all(16.0),
              // itemCount: content.length,
              itemCount: snapshot.data.documents.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return AddItemContainer();
                }
                return FileItemContainer(
                  name: snapshot.data.documents[index - 1]["name"],
                  version: snapshot.data.documents[index - 1]["version"],
                  time: snapshot.data.documents[index - 1]["timestamp"],
                );
              });
        });
  }
}

class AddItemContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Theme.of(context).accentColor.withAlpha(0x22),
        child: Center(
            child: IconButton(
          icon: Icon(Icons.add),
          // TODO: onTap function
          // file_picker plugin
          // + storage and database push (with timestamp)
          onPressed: () => print("Add file"),
        )),
      ),
    );
  }
}

class FileItemContainer extends StatelessWidget {
  final String version, name, image, time;

  FileItemContainer(
      {@required this.version,
      @required this.name,
      this.image,
      @required this.time});

  // TODO: Fetch image url from path of image variable

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        // TODO: onTap function
        // Fetch and open file
        onTap: () => print("File tapped"),
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // TODO: Padding not responsive
                  padding: EdgeInsets.only(bottom: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.timeline,
                            size: 16,
                            // TODO: Define color from custom theme?
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              time,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      image != null
                          ? Image.network(image)
                          : Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    version,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
