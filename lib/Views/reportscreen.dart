import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/model/report.dart';

class ReportScreen extends StatefulWidget {
  final String reportType;
  final String? postId;
  final String? commentId;
  final String? reportedUserId;

  const ReportScreen({
    super.key,
    required this.reportType,
    this.postId,
    this.commentId,
    this.reportedUserId,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedReason;
  final TextEditingController customReasonController = TextEditingController();
  bool showCustomInput = false;

  List<String> get reportReasons {
    switch (widget.reportType.toLowerCase()) {
      case 'post':
        return [
          'Spam or misleading',
          'Harassment or bullying',
          'Hate speech or symbols',
          'Violence or dangerous content',
          'Nudity or sexual content',
          'False information',
          'Intellectual property violation',
          'Other',
        ];
      case 'comment':
        return [
          'Spam or misleading',
          'Harassment or bullying',
          'Hate speech',
          'Threats or violence',
          'Inappropriate content',
          'Off-topic or irrelevant',
          'Other',
        ];
      case 'user':
        return [
          'Impersonation',
          'Spam account',
          'Harassment or bullying',
          'Hate speech',
          'Inappropriate profile content',
          'Underage user',
          'Suspicious activity',
          'Other',
        ];
      default:
        return ['Other'];
    }
  }

  String get screenTitle {
    switch (widget.reportType.toLowerCase()) {
      case 'post':
        return 'Report Post';
      case 'comment':
        return 'Report Comment';
      case 'user':
        return 'Report User';
      default:
        return 'Report';
    }
  }

  void handleSubmit() {
    final reportContent = showCustomInput
        ? customReasonController.text.trim()
        : selectedReason ?? '';

    if (reportContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or enter a reason'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final user = context.read<UserBloc>().state.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not found. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final Report report = Report(
      reportId: DateTime.now().millisecondsSinceEpoch.toString(),
      reporterUserId: user.id.toString(),
      isPostReport: widget.reportType.toLowerCase() == 'post',
      isCommentReport: widget.reportType.toLowerCase() == 'comment',
      isUserReport: widget.reportType.toLowerCase() == 'user',
      postId: widget.postId,
      commentId: widget.commentId,
      reportedUserId: widget.reportedUserId,
      reportContent: reportContent,
      reportTime: DateTime.now(),
      isSeenByModerator: false,
      reportStatus: 'pending',
    );

    context.read<UserBloc>().add(SubmitReport(report: report));
  }

  @override
  void dispose() {
    customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.reportSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Report submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }

        if (state.reportError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.reportError!),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            screenTitle,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why are you reporting this ${widget.reportType.toLowerCase()}?',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Your report is anonymous. If someone is in immediate danger, call local emergency services.',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    ...reportReasons.map((reason) {
                      final isSelected = selectedReason == reason;
                      final isOther = reason == 'Other';

                      return Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedReason = reason;
                                  showCustomInput = isOther;
                                  if (!isOther) {
                                    customReasonController.clear();
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : theme.dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: colorScheme.onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                        ],
                      );
                    }).toList(),
                    if (showCustomInput) ...[
                      SizedBox(height: 1.h),
                      TextField(
                        controller: customReasonController,
                        maxLines: 4,
                        maxLength: 500,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Please describe the issue...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isSubmittingReport ? null : handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.8.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state.isSubmittingReport
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Submit Report',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}