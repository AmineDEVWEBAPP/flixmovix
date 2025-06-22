class ImageAssets {
  final String errorImage = 'assets/images/error_image.jpg';
  final String logo = 'assets/images/logo.png';
  final String sun = 'assets/images/sun.png';
  final String moon = 'assets/images/moon.png';
  final String whatsapp = 'assets/images/whatsapp.png';
  final String gmail = 'assets/images/gmail.png';
  final String copy = 'assets/images/copy.png';
  final String splashScreen = 'assets/images/splashScreen.png';
}

class SvgAssets {
  final String noWifi = 'assets/svg/no_wifi.svg';
  final String error = 'assets/svg/error.svg';
  final String play = 'assets/svg/play.svg';
  final String restart = 'assets/svg/restart.svg';
  final String share = 'assets/svg/share.svg';
  final String whatsapp = 'assets/svg/whatsapp.svg';
}

class AppAsset {
  ImageAssets get images => ImageAssets();
  SvgAssets get svgs => SvgAssets();
}
