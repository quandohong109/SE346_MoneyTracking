import 'package:money_tracking/functions/converter.dart';
import 'package:money_tracking/objects/dtos/category_dto.dart';

import '../../objects/dtos/transaction_dto.dart';
import '../../objects/dtos/wallet_dto.dart';

class Firebase {
  static final Firebase _firebase = Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();

  List<CategoryDTO> categoryList = [
    CategoryDTO(
        id: 1,
        name: "Category 1",
        iconID: 1,
        type: 0,
        red: 202,
        green: 111,
        blue: 111,
        opacity: 70,
        userID: "abc"),
    CategoryDTO(
        id: 2,
        name: "Category 2",
        iconID: 2,
        type: 0,
        red: 111,
        green: 202,
        blue: 111,
        opacity: 90,
        userID: "abc"),
    CategoryDTO(
        id: 3,
        name: "Category 3",
        iconID: 3,
        type: 0,
        red: 111,
        green: 111,
        blue: 202,
        opacity: 70,
        userID: "abc"),
    CategoryDTO(
        id: 4,
        name: "Category 4",
        iconID: 4,
        type: 1,
        red: 202,
        green: 111,
        blue: 111,
        opacity: 30,
        userID: "abc"),
    CategoryDTO(
        id: 5,
        name: "Category 5",
        iconID: 5,
        type: 1,
        red: 77,
        green: 131,
        blue: 111,
        opacity: 53,
        userID: "abc"),
    CategoryDTO(
        id: 6,
        name: "Category 6",
        iconID: 6,
        type: 0,
        red: 202,
        green: 111,
        blue: 150,
        opacity: 70,
        userID: "abc"),
    CategoryDTO(
        id: 7,
        name: "Category 7",
        iconID: 7,
        type: 0,
        red: 202,
        green: 111,
        blue: 111,
        opacity: 60,
        userID: "abc"),
    CategoryDTO(
        id: 8,
        name: "Category 8",
        iconID: 8,
        type: 0,
        red: 202,
        green: 111,
        blue: 111,
        opacity: 1000,
        userID: "abc")
  ];

  List<WalletDTO> walletList = [
    WalletDTO(
        id: 1,
        name: "Wallet 1",
        iconID: 3,
        balance: BigInt.from(1200000),
        userID: "abc"),
    WalletDTO(
        id: 2,
        name: "Wallet 2",
        iconID: 5,
        balance: BigInt.from(2000000),
        userID: "abc"),
    WalletDTO(
        id: 3,
        name: "Wallet 3",
        iconID: 7,
        balance: BigInt.from(500000),
        userID: "abc"),
  ];

  List<TransactionDTO> transactionList = [
    TransactionDTO(
        id: 1,
        name: "Transaction 1",
        categoryID: 1,
        walletID: 1,
        amount: BigInt.from(100000),
        date: Converter.toTimestamp(DateTime(2024, 6, 10)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 2,
        name: "Transaction 2",
        categoryID: 2,
        walletID: 2,
        amount: BigInt.from(200000),
        date: Converter.toTimestamp(DateTime(2024, 6, 12)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 3,
        name: "Transaction 3",
        categoryID: 3,
        walletID: 1,
        amount: BigInt.from(300000),
        date: Converter.toTimestamp(DateTime(2024, 6, 12)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 4,
        name: "Transaction 4",
        categoryID: 1,
        walletID: 2,
        amount: BigInt.from(40000),
        date: Converter.toTimestamp(DateTime(2024, 6, 8)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 5,
        name: "Transaction 5",
        categoryID: 2,
        walletID: 3,
        amount: BigInt.from(500000),
        date: Converter.toTimestamp(DateTime(2024, 5, 30)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 6,
        name: "Transaction 6",
        categoryID: 3,
        walletID: 1,
        amount: BigInt.from(60000),
        date: Converter.toTimestamp(DateTime(2024, 5, 30)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 7,
        name: "Transaction 7",
        categoryID: 1,
        walletID: 2,
        amount: BigInt.from(10000),
        date: Converter.toTimestamp(DateTime(2024, 5, 29)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 8,
        name: "Transaction 8",
        categoryID: 2,
        walletID: 3,
        amount: BigInt.from(20000),
        date: Converter.toTimestamp(DateTime(2024, 5, 29)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 9,
        name: "Transaction 9",
        categoryID: 3,
        walletID: 1,
        amount: BigInt.from(30000),
        date: Converter.toTimestamp(DateTime(2024, 6, 10)),
        note: "",
        userID: "abc"),
    TransactionDTO(
        id: 10,
        name: "Transaction 10",
        categoryID: 1,
        walletID: 2,
        amount: BigInt.from(40000),
        date: Converter.toTimestamp(DateTime(2024, 5, 28)),
        note: "",
        userID: "abc"),
  ];
}