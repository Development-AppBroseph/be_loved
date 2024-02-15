import 'dart:io';
import 'dart:math';

import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/image/avatar.dart';
import 'package:be_loved/features/invite/presentation/widgets/back_button.dart';
import 'package:be_loved/features/invite/presentation/widgets/bang_dialog.dart';
import 'package:be_loved/features/invite/presentation/widgets/put_name_text_field.dart';
import 'package:be_loved/features/profile/presentation/bloc/create_virtual_partner/create_virtual_partner_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditVirtualJoker extends StatefulWidget {
  const EditVirtualJoker({super.key});

  @override
  State<EditVirtualJoker> createState() => _EditVirtualJokerState();
}

class _EditVirtualJokerState extends State<EditVirtualJoker> {
  final controller = TextEditingController();
  XFile? selectedImageFile;
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 22.h),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _buildTopPart(),
                _buildImagePicker(),
                _buildInputName(),
                SizedBox(height: 24.h),
                _buildNameTextField(),
                SizedBox(height: 32.h),
                _buildAcceptButton(),
                const Spacer(),
                _buildButtons(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility _buildAcceptButton() {
    bool shouldShowButton = _focusNode.hasFocus;

    return Visibility(
      visible: shouldShowButton,
      child: CustomButton(
        color: const Color.fromRGBO(32, 203, 131, 1.0),
        text: "Готово",
        textColor: Colors.white,
        onPressed: () {
          _focusNode.unfocus();
          setState(() {});
        },
        validate: true,
      ),
    );
  }

  Text _buildInputName() {
    return Text(
      controller.text,
      style: const TextStyle(
        color: Color(0xFF171717),
        fontSize: 22,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        height: 0.05,
      ),
    );
  }

  Widget _buildTopPart() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const BangDialog(text: "Настройки партнера"),
        SizedBox(height: 50.h),
      ],
    );
  }

  Widget _buildImagePicker() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is ImageSuccess) {
          selectedImageFile = state.image;
        }

        return PickImageContainer(
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(PickImage());
          },
          xFile: selectedImageFile,
        );
      },
    );
  }

  Widget _buildNameTextField() {
    String? errorText;
    if (controller.text.isEmpty) {
      errorText = "Поле не может быть пустым";
    } else if (controller.text.length > 12) {
      errorText = "Имя не может содержать больше 12 символов";
    } else {
      errorText = null;
    }
    return SizedBox(
      height: 59,
      child: PutNameTextField(
        errorText: errorText,
        focusNode: _focusNode,
        controller: controller,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        BlocListener<CreateVirtualPartnerBloc, CreateVirtualPartnerState>(
          listener: (context, state) {
            if (state is CreateVirtualPartnerLoaded) {
              Navigator.pop(context);
            } else if (state is CreateVirtualPartnerError) {
              print(state.errorText);
            }
          },
          child: CustomButton(
              color: const Color.fromRGBO(32, 203, 131, 1.0),
              text: "Создать",
              textColor: Colors.white,
              onPressed: () {
                File? imageFile = selectedImageFile != null
                    ? File(selectedImageFile!.path)
                    : null;
                BlocProvider.of<CreateVirtualPartnerBloc>(context).add(
                  EditVirtualPartner(name: controller.text, photo: imageFile),
                );
                Navigator.pop(context);
              },
              validate: true),
        ),
        const SizedBox(height: 20),
        _buildBackButton(),
      ],
    );
  }

  Widget _buildBackButton() {
    return BackCustomButton(
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
