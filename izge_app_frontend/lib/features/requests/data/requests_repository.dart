import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'package:flutter/material.dart';

import '../domain/models/request_item.dart';

class RequestsRepository {
  const RequestsRepository();

  List<RequestItem> get items => [
        RequestItem(
          title: 'Tekerlekli Sandalye Bakımı'.tr(),
          status: 'İşlemde',
          statusColor: Colors.orange,
          icon: Icons.accessible,
        ),
        RequestItem(
          title: 'İlaç Yardımı Başvurusu'.tr(),
          status: 'Tamamlandı',
          statusColor: Colors.green,
          icon: Icons.medication,
        ),
        RequestItem(
          title: 'Evrak Güncelleme Talebi'.tr(),
          status: 'Eksik Bilgi',
          statusColor: Colors.red,
          icon: Icons.description,
        ),
      ];
}
