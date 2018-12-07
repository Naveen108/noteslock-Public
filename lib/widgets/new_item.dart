import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/data/query.dart';
import 'package:noteslock/models/book_item.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/input_text_form_field.dart';

//import 'package:image_picker/image_picker.dart';
class NewItem extends StatefulWidget {
  final AnimationController animationController;
  final DataModel dataModel;
  NewItem({this.dataModel, this.animationController});
  @override
  _NewItem createState() =>
      _NewItem(dataModel: dataModel, animationController: animationController);
}

class _NewItem extends State<NewItem> {
  final AnimationController animationController;
  final DataModel dataModel;
  _NewItem({this.dataModel, this.animationController});
  final formKey = GlobalKey<FormState>();
  String itemTitle;
  static int bookColor = 1;
  static int bookIcon = 1;
  String bookImage;
  String itemCategory;
  String itemSubTitle;
  int boxSetFontFamily=1;
  addNewItem() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(
          '$itemTitle,$itemSubTitle,$itemCategory,$bookImage,$bookColor,$bookIcon,$boxSetFontFamily');
      Book book = Book(
        bookName: itemTitle,
        bookSubtitle: itemSubTitle,
        category: itemCategory,
        bookimage: bookImage,
        bookicon: bookIcon,
        bookcolor: bookColor,
        bookFont: boxSetFontFamily,
      );
      await dataModel.openDB().then((data) async {
        await dataModel.transaction(1, '', book).then((data) async {
          await dataModel.openDB().then((data) async {
            await dataModel.queryFunction(fethBooks).then((data) async {
              await dataModel.bookListMaker(data);
              animationController.reverse();
              print('call in fetching books and making list $data');
            });
          });
        });
      });
      formKey.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Container(
      height: screensize.height / 2.5,
      width: screensize.width / 1.0,
      margin: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 0.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(0.0),
            elevation: 8.0,
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: screensize.height / 2.5,
                      width: screensize.width / 2.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 0.0, left: 5.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: InputTextFormField(
                                  obscure: false,
                                  texttype: TextInputType.text,
                                  hinttext: "Your Book Title Here",
                                  iconType: Icon(Icons.work),
                                  errortext: "Enter Book Title",
                                  errorcheck: "",
                                  onSave: (val) => itemTitle = val,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 0.0, left: 5.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: InputTextFormField(
                                  obscure: false,
                                  texttype: TextInputType.text,
                                  hinttext: "Book\'s Subtitles",
                                  iconType: Icon(Icons.work),
                                  errortext: "Enter Subtitles Name",
                                  errorcheck: "",
                                  onSave: (val) => itemSubTitle = val,
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, left: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, right: 25.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        'Book\'s Icon',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 0.0, left: 5.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: new DropdownButton(
                                          iconSize: 40.0,
                                          value: bookIcon,
                                          items: listBookIconImages,
                                          onChanged: (int val) {
                                            bookIcon = val;
                                            setState(() {
                                              bookIcon = val;
                                            });
                                          }),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: screensize.height / 2.5,
                    width: screensize.width / 2.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 0.0, left: 5.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: InputTextFormField(
                                texttype: TextInputType.text,
                                hinttext: "Category",
                                obscure: false,
                                iconType: Icon(Icons.work),
                                errortext: "Give Category",
                                errorcheck: "",
                                onSave: (val) => itemCategory = val,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, right: 25.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'Book\'s Color',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: DropdownButton(
                                        iconSize: 40.0,
                                        value: bookColor,
                                        items: listBookColor,
                                        onChanged: (int val) {
                                          bookColor = val;
                                          setState(() {
                                            bookColor = val;
                                          });
                                        }),
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, right: 25.0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Font',
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      new FormField(
                                          //key: formIconKey2,
                                          builder: (FormFieldState state) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.0, left: 5.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: new DropdownButton(
                                                iconSize: 10.0,
                                                value: boxSetFontFamily,
                                                items: listFontFamily,
                                                onChanged: (int val) {
                                                  setState(() {
                                                    print(
                                                        'Setstate was called in fonstSIze');
                                                    boxSetFontFamily = val;

                                                    state.didChange(
                                                        boxSetFontFamily);
                                                  });
                                                }),
                                          ),
                                        );
                                      }),
                                    ]),
                                Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: IconButton(
                                        //key: quantitypluskey,
                                        onPressed: addNewItem,
                                        icon: Icon(
                                          Icons.done,
                                          size: 40.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
