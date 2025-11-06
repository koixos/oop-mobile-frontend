import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sptm/core/validators.dart';
import 'package:sptm/services/auth_service.dart';

class ForgotPasswdDialog extends StatefulWidget {
  final AuthService authService;

  const ForgotPasswdDialog({
    super.key,
    required this.authService
  });

  @override
  State<ForgotPasswdDialog> createState() => _ForgotPasswdDialogState();
}

class _ForgotPasswdDialogState extends State<ForgotPasswdDialog> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true );

    try {
      await widget.authService.requestPasswdReset(emailCtrl.text.trim());
      Fluttertoast.showToast(msg: "If an account exists for this e-mail, you will receive a code.");
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to process request. Please try again later.");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Forgot Password"),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:  Validators.validateEmail,
          decoration: const InputDecoration(
            labelText: "E-Mail",
            hintText: "you@example.com",
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: loading ? null : () => Navigator.of(context).pop(),
            child: const Text("Cancel")
        ),
        ElevatedButton(
            onPressed: loading ? null : _submit,
            child: loading ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2)
            )
                : const Text("Send Code")
        )
      ],
    );
  }
}