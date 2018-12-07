import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/models/note_item.dart';
import 'package:noteslock/theme/style.dart';
import 'package:noteslock/widgets/input_text_form_field.dart';
//import 'package:image_picker/image_picker.dart';

class NewItemNote extends StatefulWidget {
  final AnimationController animationControllerNote;
  final DataModel dataModel;
  NewItemNote({this.dataModel, this.animationControllerNote});
  @override
  _NewItemNote createState() => _NewItemNote(
      dataModel: dataModel, animationControllerNote: animationControllerNote);
}

class _NewItemNote extends State<NewItemNote> {
  final AnimationController animationControllerNote;
  final DataModel dataModel; 
  _NewItemNote({this.dataModel, this.animationControllerNote});
  final formKey = GlobalKey<FormState>();
  String itemTitle;
  static int notecolor = 1;
  static int bookIcon = 1;
  String noteimage;
  String itemCategory;
  String itemSubTitle = '';
  int boxSetFontFamily=1;
  addNewItem() async {

    if(DataModel.currentBook.bookId!=null){

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(
          '$itemTitle,$itemSubTitle,$itemCategory,$noteimage,$notecolor,$bookIcon');

      Note note = Note(
          noteTitle: itemTitle,
          noteContent: itemSubTitle,
          bookcategory: DataModel.currentBook.category,
          noteimage: noteimage,
          noteicon: bookIcon,
          notecolor: notecolor,
          bookId: DataModel.currentBook.bookId,notefont: boxSetFontFamily);
      String fetchNotes = '''
                          SELECT * 
                          FROM notes 
                          WHERE 
                          '${DataModel.currentBook.bookId}' = bookid
                          ''';
      await dataModel.openDB().then((data) async {
        await dataModel
            .transaction(2, fetchNotes, DataModel.currentBook, note)
            .then((data) async {
          animationControllerNote.reverse();
          print('call in fetching notes and making list $data');
        });
      });
      formKey.currentState.reset();
    }}
    else{
      print('Select Book first');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
   
    return Container(
      height: screensize.height / 4.5,
      width: screensize.width / 1.0,
      margin: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 0.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Card(
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
                              texttype: TextInputType.text,
                              hinttext: "Your Note Title Here",
                              iconType: Icon(Icons.work),obscure: false,
                              errortext: "Enter Note Title",
                              errorcheck: "",
                              onSave: (val) => itemTitle = val,
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
                                    'Note\'s Icon',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.0, left: 5.0),
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
                      padding: EdgeInsets.only(top: 10.0, left: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, right: 25.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Note\'s Color',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: DropdownButton(
                                    iconSize: 40.0,
                                    value: notecolor,
                                    items: listBookColor,
                                    onChanged: (int val) {
                                      notecolor = val;
                                      setState(() {
                                        notecolor = val;
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, right: 25.0),
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
                                  padding: EdgeInsets.only(top: 0.0, left: 5.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: new DropdownButton(
                                        iconSize: 10.0,
                                        value: 1,
                                        items: listFontFamily,
                                        onChanged: (int val) {
                                          setState(() {
                                            print(
                                                'Setstate was called in fonstSIze');
                                            boxSetFontFamily = val;

                                            state.didChange(boxSetFontFamily);
                                          });
                                        }),
                                  ),
                                );
                              }),]),
                            Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: IconButton(
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
    );
  }
}
