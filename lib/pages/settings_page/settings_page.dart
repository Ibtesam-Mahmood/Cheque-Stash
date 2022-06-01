
import 'package:cheque_stash/components/alert_dialog.dart';
import 'package:cheque_stash/components/settings_page/theme_color_card.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final globalStore = StoreProvider.of<GlobalState>(context);
    final colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selector'),
      ),
      body: CustomScrollView(
        slivers: [

          // Title
          const SliverPadding(
            padding: EdgeInsets.only(top: Constants.DEFAULT_PADDING, left: Constants.DEFAULT_PADDING),
            sliver: SliverToBoxAdapter(
              child: Text('Reset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ),

          // Reset data
          SliverPadding(
            padding: const EdgeInsets.only(top: Constants.MEDIUM_PADDING, left: Constants.LARGE_PADDING,),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colorTheme.error)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Reset Data', style: TextStyle(color: colorTheme.onError),),
                  ),
                  onPressed: (){
                    showDialog(context: context, builder: SimpleAlertDialog.build(
                      title: 'Reset Account', 
                      description: 'Resetting your account will wipe all data stored, along with account data and theme data.',
                      continueColor: colorTheme.error,
                      onContinue: (){
                        globalStore.dispatch(wipeDataAction);
                      }
                    ));
                  },
                ),
              )
            ),
          ),

          // Title
          const SliverPadding(
            padding: EdgeInsets.only(top: Constants.DEFAULT_PADDING, left: Constants.DEFAULT_PADDING),
            sliver: SliverToBoxAdapter(
              child: Text('Theme Style', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ),

          // Theme buttons
          SliverPadding(
            padding: const EdgeInsets.only(top: Constants.MEDIUM_PADDING, left: Constants.LARGE_PADDING),
            sliver: SliverToBoxAdapter(
              child: StoreConnector<GlobalState, ThemeMode>(
                converter: (store) => store.state.themeMode,
                builder: (context, mode) {

                  final themeModes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

                  return ToggleButtons(
                    isSelected: themeModes.map<bool>((item) => item == mode).toList(),
                    children: themeModes.map<Widget>((mode) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(mode.toString().replaceAll('ThemeMode.', '').capitalize),
                      );
                    }).toList(),
                    onPressed: (newMode){
                      globalStore.dispatch(SetThemeModeEvent(themeModes[newMode]));
                    },
                  );
                }
              ),
            ),
          ),

          // Title
          const SliverPadding(
            padding: EdgeInsets.only(top: Constants.LARGE_PADDING, left: Constants.DEFAULT_PADDING),
            sliver: SliverToBoxAdapter(
              child: Text('App Theme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ),

          // Theme selector sliver grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: Constants.MEDIUM_PADDING,
              horizontal: Constants.DEFAULT_PADDING
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: Constants.DEFAULT_PADDING,
                mainAxisSpacing: Constants.DEFAULT_PADDING,
                childAspectRatio: 1.0
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scheme = FlexScheme.values[index + 2];
                  return ThemeColorCard(scheme: scheme);
                },
                childCount: FlexScheme.values.length - 3
              ), 
            ),
          )
        ],
      ),
    );
  }
}