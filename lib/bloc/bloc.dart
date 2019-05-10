import 'package:cryptotrack/model/exchange_model.dart';
import 'package:cryptotrack/model/market_model.dart';
import 'package:cryptotrack/repository/exchange_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class Bloc{
  final BehaviorSubject<List<ExchangeModel>> _exchangeSubject = BehaviorSubject<List<ExchangeModel>>();
  final BehaviorSubject<List<MarketModel>> _marketSubject = BehaviorSubject<List<MarketModel>>();
  final BehaviorSubject<MarketModel> _summarySubject = BehaviorSubject<MarketModel>();

  Future<void> getExchanges() async{
    try {
      List<ExchangeModel> exchanges = await Repository().getExchanges();
      exchanges.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      _exchangeSubject.sink.add(exchanges);
    }catch(e){
      _exchangeSubject.addError(e);
    }
  }

  Future<void> getMarkets({@required ExchangeModel model}) async{
    try{
      List<MarketModel> markets = await Repository().getMarkets(exchange: model);
      markets.sort((a, b){
        return a.pair.toLowerCase().compareTo(b.pair.toLowerCase());
      });

      _marketSubject.sink.add(markets);
    }catch(e){
      _marketSubject.addError(e);
    }
  }

  Future<void> getSummary({@required MarketModel model}) async{
    try{
        MarketModel market = await Repository().getSummary(market: model);

        _summarySubject.sink.add(market);
    }catch(e){
      _summarySubject.addError(e);
    }
  }

  dispose(){
    _exchangeSubject.close();
    _marketSubject.close();
  }

  BehaviorSubject<List<ExchangeModel>> get exchangeSubject => _exchangeSubject;
  BehaviorSubject<List<MarketModel>> get marketSubject => _marketSubject;
  BehaviorSubject<MarketModel> get summarySubject => _summarySubject;
}

final bloc = Bloc();