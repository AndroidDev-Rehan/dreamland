// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CustomElevatedButton extends StatelessWidget {
//   const CustomElevatedButton({Key? key, required this.title, required this.onTap, this.height, this.textSize, this.width, this.gradient, this.transparent = false, this.busy=false, this.iconData, this.text2, this.text2Style,}) : super(key: key);
//   final String title;
//   final IconData? iconData;
//   final String? text2;
//   final TextStyle? text2Style;
//   final void Function()? onTap;
//   final double? height;
//   final double? textSize;
//   final double? width;
//   final Gradient? gradient;
//   final bool transparent;
//   final bool busy;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//
//         height: (height ?? 52).h,
//         width: width ?? double.infinity,
//         decoration:  BoxDecoration(
//             color: Theme.of(context).primaryColor,
//           // gradient: transparent ? null : onTap==null ? null : gradient ?? LinearGradient(colors: primaryGradient.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//           // border: transparent ? Border.all(color: primaryGradient.colors.last) : null,
//           borderRadius: BorderRadius.circular(8)
//         ),
//         child: Center(child:
//
//             busy ? const CircularProgressIndicator(color: Colors.white,) :
//
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if(iconData!=null)
//               Padding(
//                 padding: EdgeInsets.only(right: 12.w),
//                 child: Icon(iconData,
//                   // color: primaryGradient.colors.last,
//                 ),
//               ),
//             Flexible(
//               child: Text(
//                 title, style: TextStyle(
//                   color:
//                   transparent ? primaryGradient.colors.last :
//                   Colors.white,fontSize: (textSize ?? 18).sp, fontWeight: FontWeight.bold),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//
//               ),
//             ),
//             if(text2!=null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text(text2!, style:
//                 text2Style ??
//                 TextStyle(
//                     color:
//                     transparent ? primaryGradient.colors.last :
//                     Colors.white,fontSize: (textSize ?? 18).sp, fontWeight: FontWeight.bold),),
//               )
//
//           ],
//         )),
//       ),
//     );
//   }
// }
