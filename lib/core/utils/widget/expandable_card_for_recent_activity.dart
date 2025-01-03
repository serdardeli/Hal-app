// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../project/utils/widgets/expanded_card_item_for_recent_activity.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class ExpansionCardForRecentActivity extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const ExpansionCardForRecentActivity({
    Key? key,
    this.leading,
    required this.title,
    this.gif,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.color,
    this.expansionArrowColor,
    this.topMargin = 25,
  }) : super(key: key);
  final String? gif;

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget? leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color? backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget? trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Color of the title bar and icon in the expanded state.
  final Color? color;

  /// Color of the expansion arrow icon.
  final Color? expansionArrowColor;

  /// The top margin of the expansion card
  ///
  /// sets the height of the widget
  /// default is 55
  final double topMargin;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionCardForRecentActivity>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;
  late AnimationController _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    _animationController =
        AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context).readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    const Color borderSideColor = Colors.transparent; // _borderColor.value ??

    return Stack(
      children: <Widget>[
        widget.gif != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Align(
                  heightFactor:
                      _heightFactor.value < 0.5 ? 0.5 : _heightFactor.value,
                  child: Image.asset(
                    widget.gif!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Container(
          decoration: BoxDecoration(
            color: _backgroundColor.value ?? Colors.transparent,
            border: Border(
              top: BorderSide(color: borderSideColor),
              bottom: BorderSide(color: borderSideColor),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTileTheme.merge(
                  iconColor: _iconColor.value,
                  textColor: _headerColor.value,
                  child: InkWell(
                    onTap: () {
                      _handleOnPressed();

                      _handleTap();
                    },
                    child: Container(
                      //margin: EdgeInsets.only(top: widget.topMargin),
                      child: ExpandedCardItemForRecentActivity(
                        prefix: const Icon(Icons.abc),
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.title,
                          ],
                        ),
                        suffix: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                _handleOnPressed();

                                _handleTap();
                              },
                              child: Padding(
                                padding: context.padding.low * .5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.sized.lowValue * .7,
                                        horizontal: context.sized.lowValue),
                                    child: Row(
                                      children: [
                                        Text("Detay ",
                                            style: context.general.textTheme.bodyLarge!
                                                .apply(color: Colors.white)),
                                        AnimatedIcon(
                                          icon: AnimatedIcons.search_ellipsis,
                                          progress: _animationController,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              ClipRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ListTile buildDefaultListTile() {
    return ListTile(
      //  onTap: _handleTap,

      leading: widget.leading,
      title: widget.title,

      trailing: widget.trailing ??
          RotationTransition(
            turns: _iconTurns,
            child: IconButton(
              icon: Icon(
                Icons.expand_more,
                color: widget.expansionArrowColor,
              ),
              onPressed: _handleTap,
            ),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = Colors.white
      ..end = widget.color ?? const Color(0xff60c9df);
    _iconColorTween
      ..begin = Colors.white
      ..end = widget.color ?? const Color(0xff60c9df);
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
