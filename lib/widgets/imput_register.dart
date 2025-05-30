import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usuario_inri/blocs/user/auth_bloc.dart';
import 'package:usuario_inri/styles/containers_decorations.dart';
import 'package:usuario_inri/styles/text_field_decorations.dart';
import 'package:usuario_inri/utils/responsive_utils.dart';
import 'package:usuario_inri/validators/input_field_validator.dart';
import 'package:usuario_inri/widgets/dialogs/alert_screen.dart';
import 'package:usuario_inri/widgets/buttons/btn_reusable.dart';



class InputFieldConfig {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType inputType;
  final double maxWidth;
  final List<String? Function(String?)> validator;

  InputFieldConfig({
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.inputType,
    required this.validator,
    required this.maxWidth,
  });
}

class InputsUserRegister extends StatefulWidget {
  const InputsUserRegister({super.key});

  @override
  State<InputsUserRegister> createState() => _InputsUserRegisterState();
}

class _InputsUserRegisterState extends State<InputsUserRegister> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final repeatPassCtrl = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final repeatPassFocus = FocusNode();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    repeatPassCtrl.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    repeatPassFocus.dispose();
    super.dispose();
  }

  List<InputFieldConfig> _crearFields(double screenWidth) {
    return [
      InputFieldConfig(
        icon: Icons.person,
        hintText: 'Nombre completo',
        controller: nameCtrl,
        focusNode: nameFocus,
        nextFocusNode: emailFocus,
        inputType: TextInputType.name,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [InputFieldValidator.required],
      ),
      InputFieldConfig(
        icon: Icons.email,
        hintText: 'Correo electrónico',
        controller: emailCtrl,
        focusNode: emailFocus,
        nextFocusNode: passFocus,
        inputType: TextInputType.emailAddress,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [
          InputFieldValidator.required,
          InputFieldValidator.email
        ],
      ),
      InputFieldConfig(
        icon: Icons.lock_outline,
        hintText: 'Contraseña',
        controller: passCtrl,
        focusNode: passFocus,
        nextFocusNode: repeatPassFocus,
        inputType: TextInputType.text,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [
          InputFieldValidator.required,
          InputFieldValidator.password
        ],
      ),
      InputFieldConfig(
        icon: Icons.lock,
        hintText: 'Repetir contraseña',
        controller: repeatPassCtrl,
        focusNode: repeatPassFocus,
        nextFocusNode: null,
        inputType: TextInputType.text,
        maxWidth: getMaxWidth(screenWidth, 0.7),
        validator: [
          InputFieldValidator.required,
          (value) {
            if (value != passCtrl.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          }
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final fields = _crearFields(screenWidth);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          for (final field in fields)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _buildInputField(field, screenHeight, isFullWidth: true),
            ),
          const SizedBox(height: 20),
          ButtonReusable(
            text: 'Registrarme',
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
         

              final registerOk = await authBloc.initRegister(
                nameCtrl.text.trim(),
                emailCtrl.text.trim(),
                passCtrl.text.trim(),
              );
            
              if (!context.mounted) return;

              if (registerOk) {
                Navigator.pushReplacementNamed(context, 'loading');
              } else {
                mostrarAlerta(context, 'Error', 'No se pudo registrar');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(InputFieldConfig field, double screenHeight, {bool isFullWidth = false}) {
    return Container(
      width: calcularAnchoDisponible(
        context: context,
        baseWidth: field.maxWidth,
        iconWidth: 40.0,
        paddingHorizontal: 6.8,
        isFullWidth: isFullWidth,
      ),
      height: screenHeight <= 640 ? 51 : 55,
      decoration: ContainerStyles.containerDecoration(),
      child: Row(
        children: [
          _buildIconContainer(field.icon, screenHeight),
          Expanded(child: _buildTextFormField(field, screenHeight)),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Container(
        width: 38,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: const [
              Color.fromARGB(188, 126, 124, 250),
              Color.fromARGB(188, 126, 124, 250),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: screenHeight <= 380 ? 18 : 30),
      ),
    );
  }

  Widget _buildTextFormField(InputFieldConfig field, double screenHeight) {
    return TextFormField(
      controller: field.controller,
      focusNode: field.focusNode,
      cursorColor: Colors.white,
      autocorrect: false,
      keyboardType: field.inputType,
      obscureText: field.hintText.toLowerCase().contains('contraseña'),
      style: TextFieldStyles.textFieldTextStyle(),
      decoration: TextFieldStyles.inputDecoration(screenHeight, field.hintText),
      validator: (value) {
        for (final validator in field.validator) {
          final result = validator(value);
          if (result != null) return result;
        }
        return null;
      },
      onFieldSubmitted: (_) {
        if (field.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(field.nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
