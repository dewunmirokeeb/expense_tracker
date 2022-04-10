import 'package:gsheets/gsheets.dart';

class GoogleSheetApi {
  // create credentials

  static final List<List<dynamic>> currentTransaction = [];

  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "expense-tracker-346512",
  "private_key_id": "c0e9ba85aad7a27b9289e4443e65f7f3ea9024be",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCsaRJ9VkXApxzU\n4OZfIQE4i6pOhjlJgL/cN3YQCma6MOWH1H9EkdszuvW/WjL7VezLhqYi1bWqi8jv\nLp09frlU+x3i45ZKXX3rLSl/ZE0Q3n2PlyBG7XU5GZNzHo4itb+TYUqk/V2hPI1r\nAhCnTIv445oFfpf5VbqIk6bNsg25oPQcAkP5bscKTN185TpYKySydY1uULMQ9LUu\nfRRrUY5te7Ana37t4m2Qx9w9jrxW/3mAj7If+s1tZVgExVHbBXpLr6yFRwNzcn+A\nAnugb79oR8T/MHoobxcKbQ7EDEPfhUPSRAer/iECrfV2dYBJ83wxgMb61+EOoTmF\nOq1pbxPHAgMBAAECggEABZ+JsFfTf5STvqe1K84eRZNckyISlUCjQVH3wk8siY8V\ntWfrXLerIBVNdZfCCOuFBSBXo9Q3kB/uBksNateKwOhN0bwdh0BkXnrDGzoQv2ea\nTcgej+GnzJx2cC9DcINgA7UNI7N1zc/1RtOy6ln3SL9Xoy09VK8Enfa+3n+brf2x\nnHhSgNsKvsQE5wSez/A8IPa/3Ik6LRB7y5UOJ5tK99n1l+tUBkR/fkRfHIoKaeyE\niWOM9XZSXuKYHFYYg8I7ZeLqxZUyvW9uAqluI15QgeQcMu3pblcyScWoqU6V3feH\ntT94aQssaDrKNY9MHWBSscIy6DYK999H+H8Ic3V4vQKBgQDr/o0Mku5T2hFns/bf\nDCqQ8f0iIT1znmuLSL/JlZ+VyBI2Hr7GiLMEJC48cRzgm7AgrHNCPlmPFlK64NSs\n5swmMqWUls94C4y0RIn56hbpo67Gtvhzm2ij/Wxb1St9Or0lAd3ICTU6qoYB8Fz2\nrKwU/zSxJpnT70ooNtezsmXeZQKBgQC7BqaA2wdauCKWp/4gThevGDawQIyLpMIw\narKa0bB3GhKnI+5MiNAbThNw3GpRlfN9ukqBXZ0xBXTSkHu16xeYeFXi715qNvPu\nyrfTt17l6WlgIFLPXk0Ykj+0MduLl71SCmebYAFQxKP58wW2oCknWfPbktspsmIL\nhjJ5/EUguwKBgQDoeeoY6OU+VSOwNOiM8T89aiUi6fvPWdA3dYL44hxDQMQv7Dmi\n+ibffYTOpd78pGHszfT83M781dDJp5HagcG6H0peBfJ7H2WMb7g8KQ5JOqWBu90k\nhYOfiJamIGinBKYvPpdr5yY4lKNOZaoulgsu4/jUSmJfFOrIkr4Kl0MiwQKBgQCV\napy/OT1I5u8LOa83E+ysAEZAzXD7Z2eU0slaEshOftAEJBqPnoXUKq4xboaqI4hi\nG+DGNYoNzfQk/TU4g1dYglrrcJ0XckuzrNTsGgWA3NdI6sn9zbL+PGkUhviFL3cb\nAiD/6tViN5dhaxxXaOE4BQ9jjpH1YAQgfNf6yOZZXQKBgQCYO/eIFZCUIu4fPzIT\nSOHXCRFAT0spNJq3Isk5OgMClOwty8N9Q8QkhGxFiUSnhOT1sYrNiB6/1wIsaRqQ\nW9QqWiKzrK1AMQja4k4qAWrqSaXuTPzGskzdT1GfTmL9SSHhTPHo89y1qlqliemB\n8OGdjqeMMvpDStnloLyxiGcJnQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "expense-tracker@expense-tracker-346512.iam.gserviceaccount.com",
  "client_id": "111218951456726679039",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expense-tracker%40expense-tracker-346512.iam.gserviceaccount.com"
}''';

  // set up & connect to the SpreadSheet
  static const _spreadsheetId = '1ajJsnNTFPwuDLwuXtWw-YvCkxWKznubpbnYycG4B9pQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _workshet;

  static int numberofTransactions = 0;
  static bool loading = true;
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _workshet = ss.worksheetByTitle('worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _workshet!.values
            .value(column: 1, row: numberofTransactions + 1)) !=
        '') {
      numberofTransactions++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_workshet == null) {
      return;
    }
    for (int i = 1; i < numberofTransactions; i++) {
      final String transactionName =
          await _workshet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _workshet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _workshet!.values.value(column: 3, row: i + 1);
      if (currentTransaction.length < numberofTransactions) {
        currentTransaction.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    loading = false;
  }

  static double calculateincome() {
    double totalincome = 0;
    for (int i = 0; i < currentTransaction.length; i++) {
      if (currentTransaction[i][2] == 'income') {
        totalincome += double.parse(currentTransaction[i][1]);
      }
    }
    return totalincome;
  }

  static double calculateexpense() {
    double totalexpense = 0;
    for (int i = 0; i < currentTransaction.length; i++) {
      if (currentTransaction[i][2] == 'expense') {
        totalexpense += double.parse(currentTransaction[i][1]);
      }
    }
    return totalexpense;
  }

  static double balance() {
    double balance = calculateincome() - calculateexpense();
    return balance;
  }

  static Future insert(String name, String amount, bool _isincome) async {
    String send;
    if (_workshet == null) return;
    numberofTransactions++;
    currentTransaction.add(
        [name, amount, _isincome == true ? send = 'income' : send = 'expense']);
    await _workshet!.values.appendRow([name, amount, send]);
  }
}
