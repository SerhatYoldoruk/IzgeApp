import 'package:flutter/material.dart';

import '../domain/models/request_item.dart';

class RequestsRepository {
  const RequestsRepository();

  List<RequestItem> get items => const [
        RequestItem(
          title: 'Tekerlekli Sandalye Bakımı',
          status: 'İşlemde',
          statusColor: Colors.orange,
          icon: Icons.accessible,
        ),
        RequestItem(
          title: 'İlaç Yardımı Başvurusu',
          status: 'Tamamlandı',
          statusColor: Colors.green,
          icon: Icons.medication,
        ),
        RequestItem(
          title: 'Evrak Güncelleme Talebi',
          status: 'Eksik Bilgi',
          statusColor: Colors.red,
          icon: Icons.description,
        ),
      ];
}
