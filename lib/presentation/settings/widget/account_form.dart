import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/helper/logging.dart';
import 'package:trainit/presentation/settings/widget/account_header.dart';
import 'package:trainit/presentation/settings/widget/edit_photo_action_sheet.dart';
import 'package:trainit/presentation/settings/widget/seconds_input.dart';
import 'package:trainit/presentation/shared/style.dart';
import 'package:trainit/presentation/shared/export/form_components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trainit/presentation/shared/export/training_plan_card.dart';
import 'package:trainit/presentation/shared/export/tutorial_dialog.dart';
import 'package:trainit/presentation/shared/export/validators.dart';
import 'package:trainit/presentation/social/export/friends_widget.dart';

class AccountForm extends StatefulWidget {
  final Account account;
  final TrainingPlan trainingPlan;
  final Uint8List? profilePhoto;
  final Function() onSignOutClick;
  final Function(TrainingPlan) onSelectTrainingPlan;
  final Function(WeightUnit, int, int) onSave;
  final Function(Uint8List?) onSaveProfilePhoto;
  final Function() onShowFriendListClick;
  final Function() onLoadProfileClick;

  const AccountForm({
    super.key,
    required this.account,
    required this.onSignOutClick,
    required this.trainingPlan,
    required this.profilePhoto,
    required this.onSelectTrainingPlan,
    required this.onSave,
    required this.onSaveProfilePhoto,
    required this.onShowFriendListClick,
    required this.onLoadProfileClick,
  });

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  WeightUnit weightUnit = WeightUnit.kg;
  bool didChanges = false;
  int setDuration = 90;
  int setRestDuration = 90;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                AccountHeader(
                  account: widget.account,
                  profilePhoto: widget.profilePhoto,
                  onReplaceClick: _pickImage,
                ),
                _buildFriends(context),
                const SizedBox(height: 32),
                _buildDefaultsTab(context),
                const SizedBox(height: 32),
                _buildTrainingPlan(context),
              ],
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: didChanges
          ? Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onSave(weightUnit, setDuration, setRestDuration);
                      setState(() {
                        didChanges = false;
                      });
                    }
                  },
                  child: const Icon(Icons.save),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDefaultsTab(BuildContext context) {
    return FormGroup(
      AppLocalizations.of(context)!.defaults_label,
      children: [
        FormItem(
          title: AppLocalizations.of(context)!.weightunit_label,
          content: Expanded(
            child: DropdownButtonFormField(
              key: ValueKey(widget.account.weightUnit),
              value: widget.account.weightUnit,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                border: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              isExpanded: true,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              onChanged: (value) {
                setState(() {
                  if (value != widget.account.weightUnit) {
                    didChanges = true;
                  }
                  weightUnit = value!;
                });
              },
              onSaved: (value) {
                setState(() => weightUnit = value!);
              },
              validator: (value) =>
                  Validators.validateWeightUnit(value, context),
              items: WeightUnit.values.map((WeightUnit val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val.name,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        FormItem(
          title: AppLocalizations.of(context)!.set_duration_label,
          content: Expanded(
            child: SecondsInput(
              initialValue: widget.account.averageSetDuration,
              onChanged: (value) {
                setState(() {
                  final parsed = int.tryParse(value) ?? 1;
                  if (parsed != widget.account.averageSetDuration) {
                    didChanges = true;
                  }
                  setDuration = parsed;
                });
              },
              onSaved: (value) {
                if (value != null) {
                  setState(() => setDuration = int.parse(value));
                }
              },
            ),
          ),
        ),
        FormItem(
          title: AppLocalizations.of(context)!.set_rest_duration_label,
          content: Expanded(
            child: SecondsInput(
              initialValue: widget.account.averageSetRestDuration,
              onChanged: (value) {
                setState(() {
                  final parsed = int.tryParse(value) ?? 1;
                  if (parsed != widget.account.averageSetRestDuration) {
                    didChanges = true;
                  }
                  setRestDuration = parsed;
                });
              },
              onSaved: (value) {
                if (value != null) {
                  setState(() => setRestDuration = int.parse(value));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriends(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        ExportFriendsWidget(
          onShowFriendListClick: widget.onShowFriendListClick,
          onLoadProfileClick: widget.onLoadProfileClick,
        ),
      ],
    );
  }

  Widget _buildTrainingPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.training_plan_label),
        const SizedBox(height: 4),
        TrainingPlanCard(
          trainingPlan: widget.trainingPlan,
          bottomButton: TutorialEmbed(
            tutorialId: "edit_training_plan",
            child: FilledButton.icon(
              icon: const Icon(Icons.edit),
              label: Text(AppLocalizations.of(context)!.edit),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.secondary),
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.onSecondary),
              ),
              onPressed: () {
                widget.onSelectTrainingPlan(widget.trainingPlan);
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<int?> _showPickProfilePhotoAction(BuildContext givenContext) async {
    return await showModalBottomSheet<int?>(
      context: givenContext,
      useRootNavigator: true,
      isDismissible: true,
      isScrollControlled: false,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(givenContext).size.height - 60,
        minWidth: MediaQuery.of(givenContext).size.width,
      ),
      builder: (context) {
        return Padding(
          padding: screenPadding.add(EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          )),
          child: EditPhotoActionSheet(
            canBeDeleted: widget.profilePhoto == null,
            onDeleteClick: () => Navigator.pop(context, 1),
            onUpdateClick: () => Navigator.pop(context, 0),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final result = await _showPickProfilePhotoAction(context);
      if (result == 0) {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final data = await image.readAsBytes();
        widget.onSaveProfilePhoto(data);
      } else if (result == 1) {
        widget.onSaveProfilePhoto(null);
      }
    } on PlatformException catch (e) {
      Loggers.appLogger.e(e);
    }
  }
}
