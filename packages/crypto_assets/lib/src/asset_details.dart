import 'package:crypto_assets/crypto_assets.dart';
import 'package:crypto_assets/crypto_icons.dart';
import 'package:flutter/material.dart';

class AssetDetails {
  const AssetDetails._();

  static AssetDetail simplio = AssetDetail(
    name: 'Simplio',
    ticker: 'SIO',
    style: AssetStyle(
      icon: CryptoIcon.sio,
      primaryColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail bitcoin = AssetDetail(
    name: 'Bitcoin',
    ticker: 'BTC',
    style: AssetStyle(
      icon: CryptoIcon.btc,
      primaryColor: const Color(0xffff9900),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail solana = AssetDetail(
    name: 'Solana',
    ticker: 'SOL',
    style: AssetStyle(
      icon: CryptoIcon.sol,
      primaryColor: const Color(0xff411e7d),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail usdCoin = AssetDetail(
    name: 'USD Coin',
    ticker: 'USDC',
    style: AssetStyle(
      icon: CryptoIcon.usdc,
      primaryColor: const Color(0xff2775ca),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail tether = AssetDetail(
    name: 'Tether',
    ticker: 'USDT',
    style: AssetStyle(
      icon: CryptoIcon.tetherUsdt,
      primaryColor: const Color(0xff26a17b),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail bnb = AssetDetail(
    name: 'BNB',
    ticker: 'BNB',
    style: AssetStyle(
      icon: CryptoIcon.bnb,
      primaryColor: const Color(0xfff0b909),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail dai = AssetDetail(
    name: 'Dai token',
    ticker: 'DAI',
    style: AssetStyle(
      icon: CryptoIcon.bnb,
      primaryColor: const Color(0xFFDCDCDC),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail bnbSmartChain = AssetDetail(
    name: 'BNB Smart Chain',
    ticker: 'BSC',
    style: AssetStyle(
      icon: CryptoIcon.bsc,
      primaryColor: const Color(0xfff0b909),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail ethereum = AssetDetail(
    name: 'Ethereum',
    ticker: 'ETH',
    style: AssetStyle(
      icon: CryptoIcon.eth,
      primaryColor: Colors.black12,
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail chainlink = AssetDetail(
    name: 'Chainlink',
    ticker: 'CHAIN',
    style: AssetStyle(
      icon: CryptoIcon.chain,
      primaryColor: Colors.black12,
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail bitcoinCash = AssetDetail(
    name: 'Bitcoin Cash',
    ticker: 'BCH',
    style: AssetStyle(
      icon: CryptoIcon.bch,
      primaryColor: const Color(0xff8dc351),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail flux = AssetDetail(
    name: 'Flux',
    ticker: 'FLUX',
    style: AssetStyle(
      icon: CryptoIcon.zelFlux,
      primaryColor: const Color(0xff2a60d0),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail dogecoin = AssetDetail(
    name: 'Dogecoin',
    ticker: 'DOGE',
    style: AssetStyle(
      icon: CryptoIcon.doge,
      primaryColor: const Color(0xffffe4a4),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail dash = AssetDetail(
    name: 'Dash',
    ticker: 'DASH',
    style: AssetStyle(
      icon: CryptoIcon.dash,
      primaryColor: const Color(0xff008be6),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail digibyte = AssetDetail(
    name: 'Digibyte',
    ticker: 'DGB',
    style: AssetStyle(
      icon: CryptoIcon.dgb,
      primaryColor: const Color(0xff006ad2),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail litecoin = AssetDetail(
    name: 'Litecoin',
    ticker: 'LTC',
    style: AssetStyle(
      icon: CryptoIcon.ltc,
      primaryColor: const Color(0xffeaeaea),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail binanceUSD = AssetDetail(
    name: 'Binance USD',
    ticker: 'BUSD',
    style: AssetStyle(
      icon: CryptoIcon.busd,
      primaryColor: const Color(0xfff3ba2f),
      foregroundColor: Colors.white,
    ),
  );

  static AssetDetail zcash = AssetDetail(
    name: 'Zcash',
    ticker: 'ZEC',
    style: AssetStyle(
      icon: CryptoIcon.zcashZec,
      primaryColor: const Color(0xfff5df97),
      foregroundColor: Colors.white,
    ),
  );
}
