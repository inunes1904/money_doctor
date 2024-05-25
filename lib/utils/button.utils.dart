import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ButtonUtils {
  // construção de TextButton -> chamada é feita na .page -> funções no onPressed devem ser void ()=>{}
  static TextButton getTextButtons(
      {VoidCallback? functionTextButton,
      required String textButtonText,
      TextStyle? styleTextButton,
      Color? backgroundColorTextButton,}) {
    return TextButton(
      style: TextButton.styleFrom(
      backgroundColor: backgroundColorTextButton ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),
      onPressed: functionTextButton,
      child: Text(
        textButtonText,
        style: styleTextButton,
      ), 
    );
  }

  // construção de ElevatedButton -> chamada é feita na .page -> funções no onPressed devem ser void ()=>{}
  static ElevatedButton getElevatedButtons(context,
      {VoidCallback? functionElevatedButton,
      required String textElevatedButton,
      ButtonStyle? styleElevatedButton,
      IconData? elevatedButtonIcon}) {
    return ElevatedButton(
      onPressed: functionElevatedButton,
      style: styleElevatedButton,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(textElevatedButton),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Icon(elevatedButtonIcon)],
          )
        ],
      ),
    );
  }

  // construção de RadioButtons -> chamada é feita na .page
  // função deve receber pelo menos a Lista de opções radioListOptions e o valor default selectedRadioOption
  // (que tem que ser uma variável observavel, para ser actualizada)
  // na lista deve-se passar o valor / index com o texto. e.g. 1-Opção1, 2-Opção2 etc.
  static List<Widget> getRadioButtons(
      {required List<String> radioListOptions,
      required RxString selectedRadioOption,
      TextStyle? styleTextItem}) {
    return radioListOptions.map((listItemString) {
      return Row(
        children: [
          Obx(
            () => Radio<String>(
              value: listItemString,
              groupValue: selectedRadioOption.value,
              onChanged: (newValue) {
                FocusManager.instance.primaryFocus?.unfocus();
                selectedRadioOption.value = newValue!;
              },
            ),
          ),
          Text(listItemString.split("-").last, style: styleTextItem),
        ],
      );
    }).toList();
  }
}
