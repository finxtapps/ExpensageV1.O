import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoginSignupHeader extends StatefulWidget {
  final String btn_title;
  const LoginSignupHeader({super.key,
  required this.btn_title
  });

  @override
  State<LoginSignupHeader> createState() => _LoginSignupHeaderState();
}

class _LoginSignupHeaderState extends State<LoginSignupHeader> {
  @override
  Widget build(BuildContext context) {
    String description=widget.btn_title=="Sign In"?"Already have an account?":"Don't have an account?";
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 20,top: 20,bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.x,color: Colors.white,size: 28.sp,),
            //Text("X",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),//const Icon(Icons.cancel_outlined,color: Colors.white,size: 42,),
            onPressed: (){
              Navigator.pushNamed(context, '/home');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

               Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8,),
              InkWell(
                onTap: widget.btn_title=="Sign In"?(){
                  Navigator.pushNamed(context, '/signin');
                }:(){
                  Navigator.pushNamed(context, '/signup');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child:  Text(
                    widget.btn_title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

