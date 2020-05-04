import 'package:daruma/model/group.dart';
import 'package:daruma/model/member.dart';
import 'package:daruma/ui/widget/add-member-dialog.widget.dart';
import 'package:daruma/ui/widget/delete-group-dialog.widget.dart';
import 'package:daruma/ui/widget/edit-group-name-dialog.widget.dart';
import 'package:daruma/ui/widget/members-list.widget.dart';
import 'package:daruma/ui/widget/text-form-field.widget.dart';
import 'package:daruma/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class EditGroupPage extends StatefulWidget {
  final Group group;

  EditGroupPage({this.group});

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _formNewMemberKey = GlobalKey<FormState>();

  String groupId = "";
  String newName = "";
  String newMemberName = "";

  @override
  void initState() {
    groupId = widget.group.idGroup;
    newName = widget.group.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Editar grupo"),
          backgroundColor: redPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Nombre",
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  textStyle: TextStyle(color: Colors.grey)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth,
                              child: CustomTextFormField(
                                initialValue: newName,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'El nuevo nombre no puede estar vacio';
                                  }
                                  if (value == widget.group.name) {
                                    return 'El nombre es igual que antes';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    newName = value;
                                  });
                                },
                              ),
                            ),
                            RaisedButton(
                              color: redPrimaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  showDialog(
                                      context: context,
                                      child:
                                          new SimpleDialog(children: <Widget>[
                                        EditGroupNameDialog(name: newName),
                                      ]));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.done, color: white),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Guardar',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 15.0),
                      child: Text(
                        "Miembros de este grupo",
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            textStyle: TextStyle(color: Colors.grey)),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[MembersList()],
                ),
                Form(
                  key: _formNewMemberKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: halfMediaWidth * 1.3,
                              child: CustomTextFormField(
                                hintText: "Otro participante",
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'El nombre no puede estar vacio';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    newMemberName = value;
                                  });
                                },
                              ),
                            ),
                            RaisedButton(
                              color: redPrimaryColor,
                              onPressed: () {
                                if (_formNewMemberKey.currentState.validate()) {
                                  _formNewMemberKey.currentState.save();
                                  var uuid = new Uuid();

                                  Member newMember = new Member(
                                      idMember: uuid.v4(), name: newMemberName);

                                  showDialog(
                                      context: context,
                                      child:
                                          new SimpleDialog(children: <Widget>[
                                        AddMemberDialog(
                                            member: newMember,
                                            groupId: groupId),
                                      ]));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.person_add, color: white,)
                                  ],
                                ),
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                RaisedButton(
                  color: redPrimaryColor,
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new SimpleDialog(children: <Widget>[
                          DeleteDialog(groupId: groupId),
                        ]));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.delete, color: white),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Borrar',
                          style: GoogleFonts.roboto(
                              textStyle:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ));
  }
}