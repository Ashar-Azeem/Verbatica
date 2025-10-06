import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Views/Authentication%20Screens/login.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                //Disposing all the states of this user
                await TokenOperations().deleteUserProfile();
                context.read<UserBloc>().add(ClearBloc());

                //Moving to the login screen
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const Login();
                    },
                  ),
                  (_) => false,
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}

Future<Map<String, String>?> showInfoCollector(BuildContext context) async {
  String? selectedCountry;
  String selectedGender = 'Male';
  bool isCountryValid = true;

  return await showDialog<Map<String, String>>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(dialogContext).dialogBackgroundColor,
            title: Text(
              'Complete Your Profile',
              style: TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              width: 100.w,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Picker
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: dialogContext,
                          exclude: ["IL"],
                          useSafeArea: true,
                          showPhoneCode: false,
                          countryListTheme: CountryListThemeData(
                            backgroundColor:
                                Theme.of(dialogContext).scaffoldBackgroundColor,
                            textStyle: TextStyle(
                              color:
                                  Theme.of(
                                    dialogContext,
                                  ).textTheme.bodyLarge?.color,
                            ),
                            flagSize: 24,
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country.name;
                              isCountryValid = true;
                            });
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isCountryValid
                                    ? Theme.of(
                                      dialogContext,
                                    ).colorScheme.outline
                                    : Theme.of(dialogContext).colorScheme.error,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCountry ?? 'Select your country',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(
                                      dialogContext,
                                    ).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(dialogContext).iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Gender Dropdown
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            dialogContext,
                          ).colorScheme.outline.withOpacity(0.7),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Theme.of(dialogContext).cardColor,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(
                              dialogContext,
                            ).iconTheme.color?.withOpacity(0.7),
                          ),
                          hint: Text(
                            'Select Gender',
                            style: TextStyle(
                              color: Theme.of(
                                dialogContext,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              fontSize: 15,
                            ),
                          ),
                          value: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          items:
                              ['Male', 'Female']
                                  .map(
                                    (gender) => DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(
                                        gender,
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                dialogContext,
                                              ).textTheme.bodyLarge?.color,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.secondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (selectedCountry == null) {
                    setState(() => isCountryValid = false);
                    return;
                  }

                  Navigator.of(dialogContext).pop({
                    'country': selectedCountry!,
                    'gender': selectedGender,
                  });
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
