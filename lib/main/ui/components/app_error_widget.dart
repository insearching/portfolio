import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 200,
              color: Colors.red,
            ),
            SizedBox(height: 48),
            Text(
              'Oops! Something went wrong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We can\'t seem to find what you\'re looking for. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//     return const Material(
//       color: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.warning,
//               size: 200,
//               color: Colors.amber,
//             ),
//             SizedBox(height: 48),
//             Text(
//               'So... something funny happened',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'This error is crazy large it covers your whole screen. But no worries'
//               ' though, we\'re working to fix it.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
