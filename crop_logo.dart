import 'dart:io';
import 'package:image/image.dart';

void main() {
  final file = File('POSLOGO.png');
  if (!file.existsSync()) {
    print('Logo not found.');
    return;
  }
  
  final image = decodeImage(file.readAsBytesSync());
  if (image == null) {
    print('Failed to decode image.');
    return;
  }

  // Find the bounding box of non-transparent pixels
  int minX = image.width;
  int minY = image.height;
  int maxX = 0;
  int maxY = 0;
  
  bool found = false;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      if (pixel.a > 0) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
        found = true;
      }
    }
  }

  if (!found) {
    print('Image is completely transparent.');
    return;
  }

  // Add a small 5% padding around the cropped area
  int padding = ((maxX - minX) * 0.05).toInt();
  minX = (minX - padding).clamp(0, image.width);
  minY = (minY - padding).clamp(0, image.height);
  maxX = (maxX + padding).clamp(0, image.width);
  maxY = (maxY + padding).clamp(0, image.height);

  final cropped = copyCrop(image, x: minX, y: minY, width: maxX - minX, height: maxY - minY);
  
  // Create a square image with a white background for adaptive icon compatibility
  final size = cropped.width > cropped.height ? cropped.width : cropped.height;
  final square = Image(width: size, height: size);
  
  // Fill with white
  // fill(square, color: ColorRgba8(255, 255, 255, 255));
  
  // Draw the cropped image centered
  final dstX = (size - cropped.width) ~/ 2;
  final dstY = (size - cropped.height) ~/ 2;
  
  compositeImage(square, cropped, dstX: dstX, dstY: dstY);

  File('POSLOGO_cropped.png').writeAsBytesSync(encodePng(square));
  print('Successfully cropped image to POSLOGO_cropped.png');
}
