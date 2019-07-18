import 'package:equinox/equinox.dart';
import 'package:flutter/material.dart';
import 'package:fun_translate_it/src/constants.dart';
import 'package:fun_translate_it/src/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = HomeBloc();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EqLayout(
      appBar: EqAppBar(
        centerTitle: true,
        title: 'Fun Translator',
        subtitle: 'v0.0.1',
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        shrinkWrap: true,
        children: <Widget>[
          EqCard(
            shape: WidgetShape.semiRound,
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EqTextField(
                  label: 'Text',
                  shape: WidgetShape.semiRound,
                  hint: 'Eg. How are you?',
                  icon: EvaIcons.text,
                  iconPosition: Positioning.right,
                  onChanged: _bloc.textChanged,
                ),
                const SizedBox(height: 24.0),
                EqSelect(
                  label: 'Language',
                  hint: 'Select Language',
                  shape: WidgetShape.semiRound,
                  items: List.generate(
                    Constants.translators.length,
                    (int index) => EqSelectItem(
                      title: Constants.translators[index].title,
                      value: Constants.translators[index],
                    ),
                  ),
                  onSelect: _bloc.languageChanged,
                ),
              ],
            ),
            footerPadding: EdgeInsets.zero,
            footer: EqButton(
              appearance: WidgetAppearance.ghost,
              shape: WidgetShape.semiRound,
              onTap: () => _bloc.translate(),
              label: 'Translate',
              size: WidgetSize.large,
              status: WidgetStatus.primary,
            ),
          ),
          const SizedBox(height: 24.0),
          EqCard(
            shape: WidgetShape.semiRound,
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Center(
              child: StreamBuilder<String>(
                stream: _bloc.result,
                initialData: 'init',
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == 'init') {
                    return EqText.heading3('');
                  }
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return EqText.subtitle1(
                      snapshot.error,
                      state: TextState.danger,
                    );
                  }
                  if (snapshot.data == 'wait') {
                    return Center(child: CircularProgressIndicator());
                  }
                  return EqText.heading3(snapshot.data);
                },
              ),
            ),
            header: EqText.caption2('TRANSLATION'),
            statusAppearance: CardStatusAppearance.none,
            headerPadding:
                EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            footerPadding: EdgeInsets.zero,
            footer: Row(
              children: <Widget>[
                Expanded(
                  child: EqButton(
                    appearance: WidgetAppearance.ghost,
                    shape: WidgetShape.semiRound,
                    onTap: () => _bloc.shareText(),
                    label: 'share',
                    size: WidgetSize.medium,
                    icon: EvaIcons.share,
                    status: WidgetStatus.primary,
                  ),
                ),
                Expanded(
                  child: EqButton(
                    appearance: WidgetAppearance.ghost,
                    shape: WidgetShape.semiRound,
                    onTap: () => _bloc.copyText(),
                    label: 'copy',
                    icon: EvaIcons.copy,
                    size: WidgetSize.medium,
                    status: WidgetStatus.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
