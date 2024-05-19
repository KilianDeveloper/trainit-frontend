import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trainit/app.dart';
import 'package:trainit/data/model/dto/authentication_user.dart';
import 'package:trainit/data/model/dto/searched_profile.dart';
import 'package:trainit/data/model/profile.dart';
import 'package:trainit/presentation/shared/export/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFriendForm extends StatefulWidget {
  final SearchedProfile? searchedProfile;
  final AuthenticationUser authenticationUser;
  final Function(String) onSearchEmailClick;
  final Function(Profile, Uint8List) onProfileClick;
  final Function() onHideClick;
  final Function() onResetSearchClick;
  const AddFriendForm({
    super.key,
    required this.searchedProfile,
    required this.onSearchEmailClick,
    required this.onProfileClick,
    required this.onHideClick,
    required this.onResetSearchClick,
    required this.authenticationUser,
  });

  @override
  State<AddFriendForm> createState() => _AddFriendFormState();
}

class _AddFriendFormState extends State<AddFriendForm> {
  final _formKey = GlobalKey<FormState>();
  String? value = "";
  String? error;
  double height = 0;

  set errorText(String? value) {
    setState(() {
      error = value;
    });
  }

  _searchEmail() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSearchEmailClick(value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.search_account_instruction),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            if (height == 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  height = constraints.maxWidth / 5 * 3.5;
                });
              });
            }
            if (widget.searchedProfile == null) {
              return _buildSearchArea(constraints, context);
            } else if (widget.searchedProfile!.wasFound) {
              return _buildResult(context);
            } else {
              return _buildNoResult();
            }
          }),
          const SizedBox(height: 16),
          _buildButtonBar(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Row _buildButtonBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.searchedProfile == null)
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: Icon(
                Icons.copy_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (widget.authenticationUser.email != null) {
                  Clipboard.setData(
                      ClipboardData(text: widget.authenticationUser.email!));
                  snackbarKey.currentState?.showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!.copied_mail),
                  ));
                }
              },
            ),
          )
        else
          const SizedBox(width: 40),
        if (widget.searchedProfile == null || !widget.searchedProfile!.wasFound)
          FilledButton(
            onPressed: _bottomButtonClick,
            style: FilledButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(AppLocalizations.of(context)!.go_back),
          )
        else
          FilledButton(
            onPressed: _bottomButtonClick,
            child: Text(AppLocalizations.of(context)!.view),
          ),
        const SizedBox(width: 40),
      ],
    );
  }

  void _bottomButtonClick() {
    if (widget.searchedProfile == null) {
      widget.onHideClick();
    } else if (widget.searchedProfile!.wasFound) {
      widget.onProfileClick(
        widget.searchedProfile!.profile!,
        widget.searchedProfile!.profilePhoto!,
      );
    } else {
      widget.onResetSearchClick();
    }
  }

  SizedBox _buildResult(BuildContext context) {
    final size = height - 100;
    final image = widget.searchedProfile!.profilePhoto != null
        ? Image.memory(
            widget.searchedProfile!.profilePhoto!,
            width: size,
            height: size,
            fit: BoxFit.cover,
          )
        : Image.asset(
            "assets/profile.png",
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
    return SizedBox(
      height: height,
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: double.infinity),
            ClipRRect(
              borderRadius: BorderRadius.circular(height / 3),
              child: image,
            ),
            Text(
              widget.searchedProfile!.profile!.username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildNoResult() {
    return SizedBox(
      height: height,
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            Icon(
              Icons.search_off_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: height - 100,
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildSearchArea(BoxConstraints constraints, BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Opacity(
            opacity: .25,
            child: SvgPicture.asset(
              "assets/friends.svg",
              width: constraints.maxWidth / 5 * 4,
              height: height,
            ),
          ),
        ),
        SizedBox(
          height: constraints.maxWidth / 5 * 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSearchField(context),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: error == null ? _searchEmail : null,
                child: Text(AppLocalizations.of(context)!.search),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide.none,
        ),
        hintText: AppLocalizations.of(context)!.search_email,
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => value = newValue,
      onChanged: (value) {
        errorText = Validators.validateEmail(value, context);
        this.value = value;
      },
      validator: (value) {
        final error = Validators.validateEmail(value, context);
        errorText = error ?? this.error;
        return error;
      },
    );
  }
}
