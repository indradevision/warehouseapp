import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool selectdash = true;
  bool selectpesan = false;
  bool selectdaftaragent = false;
  bool selectadmin = false;
  bool selectbatal = false;
  bool selectriwayat = false;
  bool selectmanifest = false;
  bool selectb2c = false;
  bool swipe = false;
  var kota_asal;
  var kota_tujuan;

  TextEditingController tgl_awal = TextEditingController();
  TextEditingController tgl_akhir = TextEditingController();
  TextEditingController pnr = TextEditingController();

  // var format = DateFormat("yyyy-MM-dd");

  TextEditingController tglberangkat = TextEditingController();
  TextEditingController tglpulang = TextEditingController();
}
