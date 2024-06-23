import '../../../../objects/dtos/wallet_dto.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<WalletDTO> wallets;
  final BigInt totalBalance;

  WalletLoaded(this.wallets, this.totalBalance);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}

