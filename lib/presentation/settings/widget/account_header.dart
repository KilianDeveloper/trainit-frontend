import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trainit/data/model/account.dart';

class AccountHeader extends StatelessWidget {
  final Account account;
  final Uint8List? profilePhoto;
  final Function() onReplaceClick;

  const AccountHeader({
    super.key,
    required this.account,
    required this.profilePhoto,
    required this.onReplaceClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(flex: 4, child: SizedBox()),
            Expanded(
              flex: 5,
              child: LayoutBuilder(
                builder: (context, constraint) => Column(
                  children: [
                    Stack(children: [
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child:
                              _buildProfilePhoto(context, constraint.maxWidth)),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: _buildReplaceButton(context),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            const Expanded(flex: 4, child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          account.username,
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }

  Widget _buildProfilePhoto(BuildContext context, double size) {
    final image = profilePhoto != null
        ? Image.memory(profilePhoto!)
        : Image.asset("assets/profile.png");
    return _buildImage(
      context: context,
      size: size,
      imageProvider: image.image,
    );
  }

  Widget _buildImage({
    required BuildContext context,
    required double size,
    required ImageProvider<Object> imageProvider,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageProvider,
        ),
      ),
    );
  }

  Widget _buildReplaceButton(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 4,
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: IconButton(
        onPressed: onReplaceClick,
        color: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
