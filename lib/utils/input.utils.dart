import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneydoctor/styles/global.colors.dart';

abstract class InputUtils {
  // se devolver null, é válido
  static checkFields(
      {required value,
      required String inputFieldName,
      bool? inputFieldRequired,
      TextInputType? inputFieldTextType,
      int? inputFieldLimitedNumber}) {

    // vazio
    if (value.trim().isEmpty) {
      if (inputFieldRequired != true) {
        return null;
      }
      return 'Preenchimento obrigatório.';
    }

    if (inputFieldTextType != null) {
      // inputFieldTextType.index:
      // Text - 0; Multiline - 1; Number - 2; Phone - 3; Datetime - 4; Email - 5; Url - 6; VisiblePassword - 7; Name - 8; StreetAddress - 9; none - 10

      // Numbers and Phone
      if (inputFieldTextType.index == 2 || inputFieldTextType.index == 3) {
        if (int.tryParse(value) == null || int.tryParse(value)!.isNaN) {
          debugPrint(value);
          return 'Valor $inputFieldName inválido.';
        }
        if (inputFieldLimitedNumber != null &&
            value.length > inputFieldLimitedNumber) {
          return 'Limite de $inputFieldLimitedNumber caracteres.';
        }
      }

      // EMAIL
      if (inputFieldTextType.index == 5) {
        final emailIsValid = RegExp(r'\S+@\S+\.\S+').hasMatch(value);

        if (emailIsValid == false) {
          return "Valor $inputFieldName inválido.";
        }
      }

      // PARA A DATA || inclui-se inputFieldTextType.index == 10 (que é sem keyboard) -> porque a data é inserida pelo DatePicker
      if (inputFieldTextType.index == 4 || inputFieldTextType.index == 10) {
        var dataAtual = DateFormat('yyyyMMdd').format(DateTime.now());
        var dataPartida = value.split("/");

        // dataPartida tem que ter um array com 3 valores (dia, mês e ano)
        if (dataPartida.length == 3) {
          // reordena-se para ano mês dia para comparar com ano mês dia actual
          String dataPartidaParsed =
              dataPartida[2] + dataPartida[1] + dataPartida[0];
          // se a dataPartida for maior que a dataAtual, retorna erro
          if (int.parse(dataPartidaParsed) > int.parse(dataAtual)) {
            return "Data não pode ser posterior à actual!";
          }
        }
      }
    }

    // não retornou erros, é válido:
    return null;
  }

  // metodo para criar TextFormField
  static TextFormField getInputFields({
    required String
        inputFieldName, // utilizado na validação -> útil para devolver mensagem de erro por exemplo
    required TextEditingController inputFieldController, // controlador
    IconData? inputFieldIcon, // icon a ser utilizado no input
    TextInputType? inputFieldTextType, // utilizado no keyboard type
    bool?
        hiddenInputText, // utilizado para esconder o texto -> útil nas passwords
    int?
        inputFieldLimitedNumber, // útil para limitar o número de caracteres (telefone, cod.postal, etc, p.e.)
    bool?
        inputFieldRequired, // utilizado para declarar que o input é obrigatório
    bool?
        isDateSpecificInput, // utilizado especificamente para as datas -> útil no validate e onSaved
    String? inputFieldHintText, // útil para placeholders
    String? errorTextBD, // erro proveniente da BD
    VoidCallback?
        functionTextField, // função que pode ser passada -> utilizada no onTap
    GlobalKey<FormFieldState>?
        specificFormFieldKey, // key que pode ser passada para um FormField
  }) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      key: specificFormFieldKey,
      inputFormatters: [
        LengthLimitingTextInputFormatter(inputFieldLimitedNumber ?? 300),
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsetsDirectional.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorText: errorTextBD != null && errorTextBD != "null"
            ? errorTextBD
            : null,
        filled: true,
        fillColor: GlobalColors.lightestGreyTransparent,
        hintText: inputFieldHintText,
        labelText: inputFieldName,
        prefixIcon: inputFieldIcon != null
            ? Icon(
                inputFieldIcon,
              )
            : null,
      ),
      onTap: functionTextField,
      obscureText: hiddenInputText ?? false,
      enableSuggestions: false,
      keyboardType: inputFieldTextType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return checkFields(
            // no caso especifico de um input de data, ao utilizar um metodo como o datepicker (passando a data escolhida para o .text do controlador)
            // apesar de o .text ser actualizado, o value desse controlador não é. Por isso na validação tem que se verificar o .text do controlador
            // e não o seu value
            value:
                isDateSpecificInput != true ? value : inputFieldController.text,
            inputFieldName: inputFieldName,
            inputFieldRequired: inputFieldRequired,
            inputFieldTextType: inputFieldTextType,
            inputFieldLimitedNumber: inputFieldLimitedNumber);
      },
      onSaved: (value) {
        // ver comentário em checkFields
        inputFieldController.text =
            isDateSpecificInput != true ? value! : inputFieldController.text;
      },
    );
  }
}
