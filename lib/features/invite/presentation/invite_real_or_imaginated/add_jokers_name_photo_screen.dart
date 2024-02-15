import 'dart:io';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/image/avatar.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/confirm_relationship_screen.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/edit_virtual_joker.dart';
import 'package:be_loved/features/invite/presentation/widgets/back_button.dart';
import 'package:be_loved/features/invite/presentation/widgets/bang_dialog.dart';
import 'package:be_loved/features/invite/presentation/widgets/put_name_text_field.dart';
import 'package:be_loved/features/profile/presentation/bloc/create_virtual_partner/create_virtual_partner_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CreateVirtualJokerScreen extends StatefulWidget {
  const CreateVirtualJokerScreen({super.key});

  @override
  State<CreateVirtualJokerScreen> createState() =>
      CreateVirtualJokerScreenState();
}

class CreateVirtualJokerScreenState extends State<CreateVirtualJokerScreen> {
  final controller = TextEditingController();
  XFile? selectedImageFile;
  String? errorText;

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
                const Spacer(),
                _buildButtons(),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
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
        const BangDialog(text: "Создать партнера"),
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
    return PutNameTextField(
        errorText: errorText,
        controller: controller,
        onChanged: (value) {
          value = controller.text;
          setState(() {});
        });
  }

  Widget _buildButtons() {
    return Column(
      children: [
        BlocListener<CreateVirtualPartnerBloc, CreateVirtualPartnerState>(
          listener: (context, state) {
            if (state is CreateVirtualPartnerLoaded) {
              Navigator.pop(context);
              // showModalBottomSheet(
              //     context: context,
              //     isScrollControlled: true,
              //     backgroundColor: Colors.white,
              //     isDismissible: true,
              //     builder: (BuildContext context) {
              //       return ConfirmRelations(
              //         name: controller.text,
              //       );
              //     });
            } else if (state is CreateVirtualPartnerError) {
              Navigator.pop(context);
            }
          },
          child: CustomButton(
            color: const Color.fromRGBO(32, 203, 131, 1.0),
            text: "Создать",
            textColor: Colors.white,
            onPressed: () {
              if (controller.text.isEmpty) {
                errorText = 'Имя не может быть пустым';
                setState(() {});
              } else {
                File? imageFile = selectedImageFile != null
                    ? File(selectedImageFile!.path)
                    : null;
                BlocProvider.of<CreateVirtualPartnerBloc>(context).add(
                  CreatePartner(name: controller.text, photo: imageFile),
                );
              }
            },
            validate: true,
          ),
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
