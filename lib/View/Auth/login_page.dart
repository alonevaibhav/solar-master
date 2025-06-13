import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../Controller/login_controller.dart';
import '../../utils/drop_down.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = 0.8; // 20% smaller scale
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w * scale),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 60.h * scale),
                      _buildHeader(scale),
                      SizedBox(height: 60.h * scale),
                      _buildLoginForm(controller, scale),
                      SizedBox(height: 40.h * scale),
                      Obx(() => _buildLoginButton(controller, scale)),
                      SizedBox(height: 20.h * scale),
                      Obx(() => _buildErrorMessage(controller, scale)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 32.sp * scale,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h * scale),
        Text(
          'Sign in to continue to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp * scale,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller, double scale) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(controller, scale),
          SizedBox(height: 24.h * scale),
          _buildPasswordField(controller, scale),
          SizedBox(height: 24.h * scale),
          _buildRoleDropdown(controller, scale),
        ],
      ),
    );
  }

  Widget _buildEmailField(LoginController controller, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(
            fontSize: 16.sp * scale,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h * scale),
        TextFormField(
          controller: controller.usernameController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: controller.validateUsername,
          decoration: InputDecoration(
            hintText: 'Enter username or email...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.sp * scale,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * scale,
              vertical: 16.h * scale,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginController controller, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16.sp * scale,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h * scale),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          textInputAction: TextInputAction.next,
          validator: controller.validatePassword,
          decoration: InputDecoration(
            hintText: 'Enter password...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.sp * scale,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r * scale),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w * scale,
              vertical: 16.h * scale,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildRoleDropdown(LoginController controller, double scale) {
    return CustomDropdownField<String>(
      value: controller.selectedRole.value.isEmpty ? null : controller.selectedRole.value,
      labelText: 'Role',
      hintText: 'Select your role...',
      items: ['inspector', 'cleaner'],
      itemLabelBuilder: (item) => item,
      onChanged: (value) {
        if (value != null) {
          controller.setSelectedRole(value);
        }
      },
      validator: controller.validateRole,
      prefixIcon: Icons.work,
      borderRadius: 12.r * scale,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w * scale,
        vertical: 16.h * scale,
      ),
      labelStyle: TextStyle(
        fontSize: 16.sp * scale,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 16.sp * scale,
      ),
      itemTextStyle: TextStyle(
        fontSize: 16.sp * scale,
      ),
    );
  }

  Widget _buildLoginButton(LoginController controller, double scale) {
    return SizedBox(
      height: 56.h * scale,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r * scale),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
        ),
        child: controller.isLoading.value
            ? SizedBox(
          height: 20.h * scale,
          width: 20.w * scale,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        )
            : Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18.sp * scale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(LoginController controller, double scale) {
    if (controller.errorMessage.value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(12.w * scale),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r * scale),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          SizedBox(width: 8.w * scale),
          Expanded(
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
