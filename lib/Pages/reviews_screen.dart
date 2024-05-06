import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../CommenWidget/app_text.dart';
import '../CommenWidget/custom_text_form_field.dart';
import '../CommenWidget/reviews_container.dart';
import '../Helpers/colors.dart';


class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(text: 'Reviews',textColor: Colors.black,fontSize: 18,),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: '200 Comments',fontSize: 11,fontWeight: FontWeight.w400,textColor: AppColors.greyColor),
                  AppText(text: '155 Saved',fontSize: 11,fontWeight: FontWeight.w400,textColor: AppColors.greyColor),
                ],
              ),
              SizedBox(height: 20,),
              AppText(text: 'Leave a comment',fontSize: 14,fontWeight: FontWeight.w400,textColor: Colors.black),
              SizedBox(height: 20,),
              Container(
                width: 315,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          borderColor: Colors.transparent,
                          hintText: 'Say something...',
                        ),
                      ),
                      SizedBox(width: 7,),
                      Container(
                        height: 55,
                        width: 65,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AppText(
                            text: 'Send',
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: MediaQuery.of(context).size.height*.62,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                    itemCount: 7,
                    itemBuilder: (context,index){
                  return ReviewsContainer();
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
