import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_units/responsive_units.dart';

import '../blocs/login_form_bloc.dart';
import '../repository/auth_repository.dart';
import '../resources/colors.dart';
import '../resources/images.dart';
import '../router/app_router.dart';
import 'package:auto_route/auto_route.dart';

import '../ui/common/button.dart';
import '../ui/common/loading_dialog.dart';
import '../ui/common/row_spacer.dart';
import '../ui/common/unfocusKeybord.dart';
import '../utils/utils.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.onSuccess, this.padding = true})
      : super(key: key);

  final Function? onSuccess;
  final bool? padding;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? mail;
  String? password;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    var email = await Utils.getMailUser();
    var pwd = await Utils.getPasswordlUser();
    if (mounted) {
      setState(() {
        mail = email;
        password = pwd;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusKeyboard(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Utils.getImagePath(DeliveryImage.background)),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: loginForm(context),
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    final authRepository = context.read<AuthRepository>();

    return BlocProvider(
      create: (context) => LoginFormBloc(authRepository: authRepository),
      child: BlocConsumer<LoginFormBloc, LoginFormState>(
        listener: (context, state) {
          if (state.status == LoginFormStatus.loading) {
            LoadingDialog.show(context, root: false);
          } else if (state.status == LoginFormStatus.success) {
            LoadingDialog.hide(context);
            widget.onSuccess?.call();
            if (Utils.getMe()?.userMetadata?.role == "admin") {
              context.router.replaceAll([HomeRoute()]);
            } else {
              context.router.replaceAll([HomeEmployeRoute()]);
            }
          } else if (state.status == LoginFormStatus.failure) {
            LoadingDialog.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage ?? 'Identifiants non correctes'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (isFirst && mail != null && password != null) {
            isFirst = false;
            context.read<LoginFormBloc>().initialize(mail!, password!);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    Utils.getImagePath(DeliveryImage.logo),
                    width: 200,
                    height: 200,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    "Bienvenue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                _form(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _form(BuildContext context, LoginFormState state) {
    final bloc = context.read<LoginFormBloc>();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextField(
            onChanged: bloc.onUsernameChanged,
            controller: TextEditingController(text: state.username)..selection = TextSelection.collapsed(offset: state.username.length),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: bloc.onPasswordChanged,
            controller: TextEditingController(text: state.password)..selection = TextSelection.collapsed(offset: state.password.length),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: state.stayConnect,
                onChanged: (v) => bloc.onStayConnectChanged(v ?? true),
                side: const BorderSide(color: Colors.white),
              ),
              Text(
                'Rester connecté',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          const RowSpacer(),
          FormButton(
            labelColor: Colors.white,
            width: double.infinity,
            onPressed: bloc.submit,
            primary: DeliveryColors.blue,
            radius: 15,
            label: 'Connexion',
          ),
          const RowSpacer(),
        ],
      ),
    );
  }
}
