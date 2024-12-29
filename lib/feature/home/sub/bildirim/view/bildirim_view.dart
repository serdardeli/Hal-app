import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../../project/model/bildirim/bildirim_model.dart';
import 'package:turkish/turkish.dart';

import '../../../../../project/provider/context_provider.dart';
import '../viewmodel/cubit/bildirim_cubit.dart';

class Bildirim extends StatefulWidget {
  static const String name = "bildirim";

  const Bildirim({Key? key}) : super(key: key);

  @override
  State<Bildirim> createState() => _BildirimState();
}

class _BildirimState extends State<Bildirim> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCity;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Text("bildirim"),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    buildBildirimciSifatDropDown(),
                    /*  const Text(
                        "bildirimciye ait bilgiler burada farklı tc lerde sıfat şeçebiliyomusun webe göre neler farklı?",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                   buildBildirimciTcField(context),
                    buildBildirimciSifatDropDown(),
                    buildBildirimciAdi(context),*/
                    //  const Text("bildirim genel bilgiler",
                    //      style:  TextStyle(fontWeight: FontWeight.bold)),
                    buildBildirimTuru(),
                    buildToplamaMal(),
                    BlocBuilder<BildirimCubit, BildirimState>(
                      builder: (context, state) {
                        return context.read<BildirimCubit>().isToplamaHal
                            ? Container()
                            : Column(
                                children: [
                                  const Text("Kimden veya kime bilgileri",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  buildKimdenKimeTc(context),
                                  Text(
                                    "${context.watch<BildirimCubit>().kayitliKisiBulunamadiText} ",
                                    textAlign: TextAlign.center,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        context
                                            .read<BildirimCubit>()
                                            .kimdenKimeTcSorgula();
                                      },
                                      child: const Text("Bildirimci sorgula")),
                                  buildIkinciKisiSifatDropDown(context),
                                  buildIkinciKisiAdSoyadField(),
                                  buildIkinciKisiGsmNumarasi(),
                                ],
                              );
                      },
                    ),
                    const Text("Urune ait bilgiler",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildCityField(context),
                    buildIlceField(),
                    buildBeldeField(),
                    buildMalinAdiField(),
                    buildMalinTuruField(),
                    buildMalinCinsiField(),
                    const Text("Bildirim Türü",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    buildMalMiktariColumn(),
                    buildBirimFiyatiColumn(context),
                    const Text(
                        "Malın Gideceği / Tüketime Sunulduğu Yere Ait Bilgiler",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildGidecekYerSahibiTc(context),
                    BlocBuilder<BildirimCubit, BildirimState>(
                      builder: (context, state) {
                        return Text(
                          "${context.watch<BildirimCubit>().ikinciKisiBulunamadiText} ${context.watch<BildirimCubit>().ikinciKisiIsyeriAdi}",
                          textAlign: TextAlign.center,
                        );
                      },
                    ),

                    ElevatedButton(
                        onPressed: () {
                          context
                              .read<BildirimCubit>()
                              .malinGidecegiKisiSorgula();
                        },
                        child: const Text("Malın gideceği kişiyi sorgula")),
                    buildGidecekYerKayitlimiCheckBox(),
                    buildGidecegiYerIsletmeTurleriField(context),
                    buildAracPlakaField(context),
                    buildBelgeTipleriDropDown(),
                    buildBelgeNoTipi(context),
                    buildKaydetButton(context)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 200)
          ],
        ),
      )),
    );
  }

  ElevatedButton buildKaydetButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {

          context.read<BildirimCubit>().saveButton();
        },
        child: const Text("Kaydet"));
  }

  Padding buildBelgeNoTipi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<BildirimCubit>().belgeNoController,
        decoration: InputDecoration(
            labelText: "BelgeNo / Tipi",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildBelgeTipleriDropDown() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            const Expanded(
              child: Text("Belge tipi:  ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().belgeTipi,
                  items: context
                      .read<BildirimCubit>()
                      .getBelgeTipleri
                      .values
                      .toList()
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().belgeTipi = value!;
                    context.read<BildirimCubit>().belgeTipiSelected();
                  }),
            ),
          ],
        );
      },
    );
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<BildirimCubit>().plakaController,
        decoration: InputDecoration(
            labelText: "Araç Plaka",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Widget buildGidecegiYerIsletmeTurleriField(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Text("Gideceği Yer isletme Id: ",
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: BlocBuilder<BildirimCubit, BildirimState>(
            builder: (context, state) {
              return DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().gidecegiYerIsletmeTuru,
                  items: context
                      .read<BildirimCubit>()
                      .getIsletmeTurleri
                      .values
                      .toList()
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().gidecegiYerIsletmeTuru =
                        value!;
                    context.read<BildirimCubit>().isletmeTuruSelected();
                  });
            },
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: context.read<BildirimCubit>().isletmeTuruController,
            decoration: InputDecoration(
                labelText: 'Gideceği Yer-işletme türü',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];
          context
              .read<BildirimCubit>()
              .getIsletmeTurleri
              .values
              .forEach((element) {
            if (element.toUpperCaseTr().contains(pattern.toUpperCaseTr())) {
              list.add(element);
            }
          });
          return list;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        getImmediateSuggestions: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          context.read<BildirimCubit>().isletmeTuruController.text =
              suggestion.toString();
          context.read<BildirimCubit>().isletmeTuruSelected();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a city';
          }
        },
        onSaved: (value) => _selectedCity = value,
      ),
    );
  }

  Column buildGidecekYerSahibiTc(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [Text("Gideceği Yer Sahibi T.C. Kimlik/Vergi No")],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: context.read<BildirimCubit>().bildirimciTcController,
            decoration: InputDecoration(
                labelText: "TC / Vergi No",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        ),
      ],
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildGidecekYerKayitlimiCheckBox() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: context.read<BildirimCubit>().gidecekYerKayitlimi,
              onChanged: (bool? value) {
                context.read<BildirimCubit>().gidecekYerKayitlimi = value!;
                context.read<BildirimCubit>().gidecekYerKayitlimiSelected();
              },
            ),
            const Text("Gidecek Yer Kayıtlı Değil")
          ],
        );
      },
    );
  }

  Column buildBirimFiyatiColumn(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [Text("Birim Fiyatı")],
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: context.read<BildirimCubit>().tlController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "TL",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: context.read<BildirimCubit>().kurusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "KURUŞ",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ))
          ],
        )
      ],
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildMalMiktariColumn() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Mal Miktarı ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: context.read<BildirimCubit>().malMiktarBirimAdi,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            (context.read<BildirimCubit>().malMiktarBirimAdi.toLowerCase() ==
                    "kg")
                ? Row(
                    children: [
                      Expanded(child: buildBagAdetKgField(context)),
                      Expanded(child: buildGramField(context))
                    ],
                  )
                : buildBagAdetKgField(context)
          ],
        );
      },
    );
  }

  Padding buildGramField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled:
            context.read<BildirimCubit>().malinAdiController.text.trim() != "",
        controller: context.read<BildirimCubit>().gramController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "gram",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildBagAdetKgField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled:
            context.read<BildirimCubit>().malinAdiController.text.trim() != "",
        controller: context.read<BildirimCubit>().adetBagKgController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: context.read<BildirimCubit>().malMiktarBirimAdi,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildAnalizCheckBox() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              // fillColor: MaterialStateProperty.resolveWith(getColor),
              value: context.read<BildirimCubit>().isAnaliz,
              onChanged: (bool? value) {
                context.read<BildirimCubit>().isAnaliz = value!;
                context.read<BildirimCubit>().analizSelected();
              },
            ),
            const Text("Analize Gönder")
          ],
        );
      },
    );
  }

  Padding buildIkinciKisiGsmNumarasi() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<BildirimCubit>().ikinciKisCepTelController,
        decoration: InputDecoration(
            labelText: "GSM Numarası",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildIkinciKisiAdSoyadField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<BildirimCubit>().ikinciKisiAdSoyadController,
        decoration: InputDecoration(
            labelText: "Ad Soyad / Unvan",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Widget buildIkinciKisiSifatDropDown(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Text("Kimden Sifatı : ",
                style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: BlocBuilder<BildirimCubit, BildirimState>(
            builder: (context, state) {
              return DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().ikinciKisiSifat,
                  items: context
                      .read<BildirimCubit>()
                      .getSifatlar
                      .values
                      .toList()
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().ikinciKisiSifat = value!;
                    context.read<BildirimCubit>().ikinciKisiSifatSelected();
                  });
            },
          ),
        ),
      ],
    );
  }

  Padding buildIkinciKisiEpostaField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "E posta",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildKimdenKimeTc(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<BildirimCubit>().kimdenKimeTcController,
        decoration: InputDecoration(
            labelText: "TC",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildToplamaMal() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              // fillColor: MaterialStateProperty.resolveWith(getColor),
              value: context.read<BildirimCubit>().isToplamaHal,
              onChanged: (bool? value) {
                context.read<BildirimCubit>().isToplamaHal = value!;
                context.read<BildirimCubit>().toplamaMalSelected();
              },
            ),
            const Text("Toplama mal")
          ],
        );
      },
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildBildirimTuru() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            const Expanded(
              child: Text("Bildirim Türü: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().bildirimTuru,
                  items: context
                      .read<BildirimCubit>()
                      .getBildirimTurleri
                      .values
                      .toList()
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().bildirimTuru = value!;
                    context.read<BildirimCubit>().bildirimTuruSelected();
                  }),
            ),
          ],
        );
      },
    );
  }

  Text buildBildirimciAdi(BuildContext context) {
    return Text(
        context.read<BildirimCubit>().halIciIsyeri["IsyeriAdi"].toString());
  }

  BlocBuilder<BildirimCubit, BildirimState> buildBildirimciSifatDropDown() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            const Expanded(
                child: Text("Bildirimci Sifat: ",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().bildirimciSifat,
                  items: context
                      .read<BildirimCubit>()
                      .getKayitliKisiSifatlari
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e, overflow: TextOverflow.visible),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().bildirimciSifat = value!;
                    context.read<BildirimCubit>().bildirimciSifatSelected();
                  }),
            ),
          ],
        );
      },
    );
  }

  TextFormField buildBildirimciTcField(BuildContext context) {
    return TextFormField(
      controller: context.read<BildirimCubit>().bildirimciTcController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: "TC",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildMalinCinsiField() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Row(
          children: [
            const Expanded(
                child: Text("Malin Cinsi: ",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<BildirimCubit>().malinCins,
                  items: context
                      .read<BildirimCubit>()
                      .urunCinsiIsimleriList
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e, overflow: TextOverflow.visible),
                          ))
                      .toList(),
                  onChanged: (value) {
                    context.read<BildirimCubit>().malinCins = value!;
                    context.read<BildirimCubit>().malinCinsiSelected();
                  }),
            ),
          ],
        );
      },
    );

    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: context.read<BildirimCubit>().malinCinsiController,
                decoration: InputDecoration(
                    labelText: 'Malın Cinsi',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];
              context
                  .read<BildirimCubit>()
                  .urunCinsiIsimleriList
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<BildirimCubit>().malinCinsiController.text =
                  suggestion.toString();
              context.read<BildirimCubit>().malinCinsiSelected();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
            },
            onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildMalinTuruField() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: context.read<BildirimCubit>().malinTuruController,
                decoration: InputDecoration(
                    labelText: 'Malın Turu',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];
              context.read<BildirimCubit>().getTurler.values.forEach((element) {
                if ((element as String)
                    .toUpperCaseTr()
                    .contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<BildirimCubit>().malinTuruController.text =
                  suggestion.toString();
              context.read<BildirimCubit>().malinTuruSelected();

              context.read<BildirimCubit>().malinAdiAndMalinTuruSelected();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
            onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildMalinAdiField() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: context.read<BildirimCubit>().malinAdiController,
                decoration: InputDecoration(
                    labelText: 'Malın adı',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];
              context.read<BildirimCubit>().getMallar.values.forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<BildirimCubit>().malinAdiController.text =
                  suggestion.toString();
              context.read<BildirimCubit>().malinAdiSelected();

              context.read<BildirimCubit>().malinAdiAndMalinTuruSelected();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
            onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildBeldeField() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                enabled:
                    (context
                                    .read<BildirimCubit>()
                                    .ilceController
                                    .text
                                    .trim() ==
                                "")
                        ? false
                        : true,
                controller: context.read<BildirimCubit>().beldeController,
                decoration: InputDecoration(
                    labelText: 'Belde',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<BildirimCubit>()
                  .getBeldeler
                  .values
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<BildirimCubit>().beldeController.text =
                  suggestion.toString();
              context.read<BildirimCubit>().beldeSelected();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
            onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<BildirimCubit, BildirimState> buildIlceField() {
    return BlocBuilder<BildirimCubit, BildirimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                enabled:
                    (context
                                    .read<BildirimCubit>()
                                    .cityController
                                    .text
                                    .trim() ==
                                "")
                        ? false
                        : true,
                controller: context.read<BildirimCubit>().ilceController,
                decoration: InputDecoration(
                    labelText: 'İlçe',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<BildirimCubit>()
                  .getIlceler
                  .values
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<BildirimCubit>().ilceController.text =
                  suggestion.toString();
              context.read<BildirimCubit>().ilceSelected();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
            onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  Widget buildCityField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: context.read<BildirimCubit>().cityController,
            decoration: InputDecoration(
                labelText: 'İl',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context.read<BildirimCubit>().getCities.values.forEach((element) {
            if (element.contains(pattern.toUpperCaseTr())) {
              list.add(element);
            }
          });
          return list;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        getImmediateSuggestions: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          context.read<BildirimCubit>().cityController.text =
              suggestion.toString();
          context.read<BildirimCubit>().citySelected();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a city';
          }
          return null;
        },
        onSaved: (value) => _selectedCity = value,
      ),
    );
  }
}
