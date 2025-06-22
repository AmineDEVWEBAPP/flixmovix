import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../config/app_config.dart';
import '../utils/methodes.dart';
import 'http_service.dart';

class ScrappingService {
  static final ScrappingService _instance = ScrappingService();
  ScrappingService get instance => _instance;
  bool getByCollection = false;
  String baseUrl = AppConfig().instance.baseUrl;
  bool isSearch = false;

  //* get Items
  static Future<Map<String, dynamic>> getItems(
      {bool? newItems, int? pageNum, word}) async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({
          'connectionStatus': true,
          'body': {'collections': <dynamic>{}, 'items': <dynamic>{}}
        });
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      String apiUrl = _instance.isSearch == false
          ? (newItems == true
              ? (_instance.getByCollection == false
                  ? '${_instance.baseUrl}/page/$pageNum/'
                  : '${_instance.baseUrl}?page_no=$pageNum')
              : _instance.baseUrl)
          : '${AppConfig().instance.baseUrl}/AjaxCenter/Searching/$word';
      Response response = await HttpService.getRequest(apiUrl);
      data.addAll({'statusCode': response.statusCode});
      if (response.statusCode != 200 && response.statusCode != 201) {
        data.addAll({
          'error': {'status': true, 'body': response.body}
        });
        return data;
      }
      String html = response.body;
      BeautifulSoup bs = BeautifulSoup(
          _instance.isSearch == false ? html : jsonDecode(html)['output']);

      List<Bs4Element>? items = bs
          .find('div', class_: 'Grid--WecimaPosts')
          ?.findAll('div', class_: 'Thumb--GridItem');

      items?.forEach((item) {
        String? href = item.find('a')?.attributes['href'];
        String? title = item.find('a')?.attributes['title'];
        String? year = item.find('span', class_: 'year')?.text.trim();
        //< get Image Url
        RegExp regExp = RegExp(r'url\(([^)]+)\)');
        String? getImageUrl = item
            .find('span', class_: 'BG--GridItem')
            ?.attributes['data-lazy-style'];
        Match? match = regExp.firstMatch(getImageUrl ?? '');
        String? imageUrl = match?.group(1);
        //>
        String? episode = item
            .find('div', class_: 'Episode--number')
            ?.find('span')
            ?.text
            .trim();
        if (episode != null) {
          data['body']['items'].add({
            'title': title,
            'imageUrl': imageUrl,
            'episode': episode,
            'year': year,
            'href': href,
            'isFilm': false,
          });
        } else {
          data['body']['items'].add({
            'title': title,
            'imageUrl': imageUrl,
            'year': year,
            'href': href,
            'isFilm': true,
          });
        }
      });
      //< get Collections
      List<Bs4Element>? collections =
          bs.find('div', class_: 'list--Tabsui')?.findAll('a');
      collections?.forEach((element) {
        String? href = element.attributes['href'];
        String? name = element.text;
        data['body']['collections'].add({'href': href, 'name': name});
      });
      //>
      data.addAll({
        'error': {'status': false}
      });
    } catch (e) {
      logger('Error : $e');
      data.addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }
    logger('finish scrapping');
    return data;
  }

//* get item details
  static Future<Map<String, dynamic>> getItemDetails(String href) async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({
          'connectionStatus': true,
          'body': {
            'details': {},
            'similarOffer': <dynamic>{},
            'seasions': <dynamic>{}
          }
        });
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      Response? response = await HttpService.getRequest(href);
      data.addAll({'statusCode': response.statusCode});
      if (response.statusCode != 200 && response.statusCode != 201) {
        data.addAll({
          'error': {'status': true, 'body': response.body}
        });
        return data;
      }
      String html = response.body;
      BeautifulSoup bs = BeautifulSoup(html);
      String? title = bs
          .find('a', class_: 'unline', attrs: {'href': href})
          ?.find('span')
          ?.text
          .trim();
      String? year = bs
          .find('div', class_: 'Title--Content--Single-begin')
          ?.find('h1', attrs: {'dir': 'auto', 'itemprop': 'name'})
          ?.find('a', class_: 'unline')
          ?.text
          .trim();
      //< get Image Url
      RegExp regExp = RegExp(r'url\(([^)]+)\)');
      String? getImageUrl = bs
          .find('wecima', class_: 'separated--top')
          ?.attributes['data-lazy-style'];
      Match? match = regExp.firstMatch(getImageUrl ?? '');
      String? imageUrl = match?.group(1);
      //>

      //< find details
      List<Bs4Element>? allDetails =
          bs.find('ul', class_: 'Terms--Content--Single-begin')?.findAll('li');
      List<Bs4Element> detailsList = [];
      Map<String?, String?> m = {};
      allDetails?.forEach((detail) {
        detailsList.add(detail);
      });
      for (int i = 0; i < detailsList.length; i++) {
        m.addAll({
          detailsList[i].find('span')?.text:
              detailsList[i].find('p')?.text.trim()
        });
      }
      String? arabicName =
          m.containsKey('الإسم بالعربي') ? m['الإسم بالعربي'] : m['المسلسل'];
      String? quality = m.containsKey('الجودة') ? m['الجودة'] : null;
      String? type = m['النوع'];
      String? duration = m.containsKey('المدة') ? m['المدة'] : null;
      String? alsoKnownAs =
          m.containsKey('معروف ايضاََ بـ') ? m['معروف ايضاََ بـ'] : null;
      String? classification = m.containsKey('التصنيف') ? m['التصنيف'] : null;
      //>

      String? storyMovie =
          bs.find('div', class_: 'StoryMovieContent')?.text.trim();
      String? iframe = bs.find('iframe')?.attributes['data-lazy-src'];
      Map<String, dynamic> details = {
        'title': title,
        'imageUrl': imageUrl,
        'year': year,
        'arabicName': arabicName,
        'quality': quality,
        'type': type,
        'alsoKnownAs': alsoKnownAs,
        'classification': classification,
        'duration': duration,
        'storyMovie': storyMovie,
        'iframe': iframe,
      };
      data['body']['details'].addAll(details);
      //< find seasions
      List<Bs4Element>? seasionsList =
          bs.find('div', class_: 'List--Seasons--Episodes')?.findAll('a');
      List seasions = [];
      if (seasionsList != null) {
        for (Bs4Element seasion in seasionsList) {
          bool selected = seasion.className == 'selected';
          seasions.add({
            seasion.text: {
              'href': seasion.attributes['href'],
              'selected': selected
            }
          });
        }
      }
      data['body']['seasions'].addAll(seasions);
      //>

      //< find episodes
      List<Bs4Element>? episodesList =
          bs.find('div', class_: 'Episodes--Seasons--Episodes')?.findAll('a');
      Set episodes = {};
      if (episodesList != null) {
        for (int i = 0; i < episodesList.length; i++) {
          // ignore: dead_code
          episodes.add({
            'name': episodesList[i].text,
            'href': episodesList[i].attributes['href'],
            'selected':
                episodesList[i].className == 'hoverable activable selected'
          });
        }

        data['body']['details']
            .addAll({'episodes': episodes.toSet(), 'isFilm': false});
      } else {
        data['body']['details'].addAll({'episodes': episodes, 'isFilm': true});
      }
      //>

      //< find Similar offer
      List<Bs4Element>? similarOffer = bs
          .find('div', class_: 'Grid--WecimaPosts')
          ?.findAll('div', class_: 'Thumb--GridItem');
      similarOffer?.forEach((item) {
        String? href = item.find('a')?.attributes['href'];
        String? title = item.find('a')?.attributes['title'];
        String? year = item.find('span', class_: 'year')?.text.trim();
        //< get Image Url
        RegExp regExp = RegExp(r'url\(([^)]+)\)');
        String? getImageUrl = item
            .find('span', class_: 'BG--GridItem')
            ?.attributes['data-lazy-style'];
        Match? match = regExp.firstMatch(getImageUrl ?? '');
        String? imageUrl = match?.group(1);
        //>
        String? episode = item
            .find('div', class_: 'Episode--number')
            ?.find('span')
            ?.text
            .trim();
        if (episode != null) {
          data['body']['similarOffer'].add({
            'title': title,
            'imageUrl': imageUrl,
            'episode': episode,
            'year': year,
            'href': href,
            'isFilm': false,
          });
        } else {
          data['body']['similarOffer'].add({
            'title': title,
            'imageUrl': imageUrl,
            'year': year,
            'href': href,
            'isFilm': true,
          });
        }
      });
      //>
      data.addAll({
        'error': {'status': false}
      });
    } catch (e) {
      logger('scrapping error : $e');
      data.addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }

    logger('finish scrapping');
    return data;
  }

//* get Collections
  static Future<Map<String, dynamic>> getCategorys(String? html,
      {bool? hasError, WebResourceError? error}) async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({
          'connectionStatus': true,
          'body': {'categorys': <dynamic>{}}
        });
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      if (hasError == true) {
        data.addAll({
          'statusCode': error.hashCode,
          'error': {'status': true, 'body': error?.description}
        });
        return data;
      }

      BeautifulSoup bs = BeautifulSoup(html ?? '');
      List<Bs4Element>? categorys = bs
          .find(
            'ul',
            class_: 'menu-userarea--rightbar',
          )
          ?.findAll('li');
      categorys?.forEach((collection) {
        String? name = collection.text;
        String? href = collection.find('a')?.attributes['href'];
        bool? isSellected = collection.className == 'selected';
        data['body']['categorys'].add({
          'name': name,
          'href': href,
          'isSellected': isSellected,
        });
      });
      data.addAll({
        'error': {'status': false}
      });
    } catch (e) {
      data.addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }
    logger('finish scrapping');
    return data;
  }
}
