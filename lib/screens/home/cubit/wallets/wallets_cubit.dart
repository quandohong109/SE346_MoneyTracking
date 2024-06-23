import 'package:bloc/bloc.dart';
import 'package:money_tracking/data/firebase/firebase.dart';
import '../../../../objects/dtos/wallet_dto.dart';
import 'wallets_state.dart';

abstract class WalletEvent {}

class LoadWallets extends WalletEvent {}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  List<WalletDTO> wallets = [];

  WalletBloc() : super(WalletInitial()){
    Firebase firebaseInstance = Firebase();

    wallets = firebaseInstance.walletList;

    add(LoadWallets());
  }

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is LoadWallets) {
      yield WalletLoading();
      try {
        // Calculate the total balance
        BigInt totalBalance = wallets.fold(BigInt.zero, (prev, element) => prev + element.balance);
        yield WalletLoaded(wallets, totalBalance);
      } catch (e) {
        yield WalletError(e.toString());
      }
    }
  }
}