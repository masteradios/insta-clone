import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveUI extends StatefulWidget {
  final Widget MobileScreenLayout;
  final Widget WebLayout;
   ResponsiveUI({required this.MobileScreenLayout,required this.WebLayout});

  @override
  State<ResponsiveUI> createState() => _ResponsiveUIState();
}

class _ResponsiveUIState extends State<ResponsiveUI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData()async
  {
    UserProvider _userProvider=Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraint){
      if(constraint.maxWidth>=600)
      {
        return widget.WebLayout;
      }
      return widget.MobileScreenLayout;
    });
  }
}
