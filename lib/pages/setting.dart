import 'package:download_manager/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return (Device.get().isPhone) ? _smartPhoneLayout() : (Device.width > Device.height ? _tabletLandscapeLayout() : _tabletPortraitLayout());
  }

  Widget _smartPhoneLayout() {
    return  Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      // color: Theme.of(context).backgroundColor,
      child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _appBar(context)
            ),
            Expanded(
              flex: 8,
              child: Container(
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
    );
  }

  Widget _tabletLandscapeLayout() {
    return _smartPhoneLayout();
  }

  Widget _tabletPortraitLayout() {
    return _smartPhoneLayout();
  }

  Widget _appBar(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _backToHomePage();
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    // width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          size: 28,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text("Close",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
            ],
          ),
        );
      },
    );
  }

  void _backToHomePage() {
    Navigator.pop(context);
  }
}
