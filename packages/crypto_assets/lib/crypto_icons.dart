import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Map<String, String> assetNames = {
  'avax': 'assets/svg_icons/avalanche-avax.svg',
  'btc': 'assets/svg_icons/Bitcoin-btc.svg',
  'bch': 'assets/svg_icons/bitcoin-cash-bch.svg',
  'bnb': 'assets/svg_icons/bnb.svg',
  'bsc': 'assets/svg_icons/bnb-smart-chain.svg',
  'busd': 'assets/svg_icons/binance-usd.svg',
  'cosmos_atom': 'assets/svg_icons/cosmos-atom.svg',
  'chain': 'assets/svg_icons/chainlink.svg',
  'dash': 'assets/svg_icons/dash-dash.svg',
  'dgb': 'assets/svg_icons/digibyte-dgb.svg',
  'doge': 'assets/svg_icons/dogecoin.svg',
  'eth': 'assets/svg_icons/ethereum-classic-eth.svg',
  'ltc': 'assets/svg_icons/litecoin-ltc.svg',
  'osmo': 'assets/svg_icons/osmo.svg',
  'polygon_matic': 'assets/svg_icons/polygon-matic.svg',
  'sol': 'assets/svg_icons/solana-sol.svg',
  'sio': 'assets/svg_icons/simplio.svg',
  'tether': 'assets/svg_icons/tether-usdt.svg',
  'usdc': 'assets/svg_icons/usd-coin.svg',
  'zcash_zec': 'assets/svg_icons/zcash-zec.svg',
  'zel_flux': 'assets/svg_icons/zel-flux.svg',
};

class CryptoIcon {
  CryptoIcon._();

  static Widget get avax =>
      SvgPicture.asset(assetNames['avax']!, package: 'crypto_assets');

  static Widget get btc =>
      SvgPicture.asset(assetNames['btc']!, package: 'crypto_assets');

  static Widget get bch =>
      SvgPicture.asset(assetNames['bch']!, package: 'crypto_assets');

  static Widget get bnb =>
      SvgPicture.asset(assetNames['bnb']!, package: 'crypto_assets');

  static Widget get bsc =>
      SvgPicture.asset(assetNames['bsc']!, package: 'crypto_assets');

  static Widget get busd =>
      SvgPicture.asset(assetNames['busd']!, package: 'crypto_assets');

  static Widget get cosmosAtom =>
      SvgPicture.asset(assetNames['cosmos_atom']!, package: 'crypto_assets');

  static Widget get chain =>
      SvgPicture.asset(assetNames['chain']!, package: 'crypto_assets');

  static Widget get dash =>
      SvgPicture.asset(assetNames['dash_atom']!, package: 'crypto_assets');

  static Widget get dgb =>
      SvgPicture.asset(assetNames['dgb']!, package: 'crypto_assets');

  static Widget get doge =>
      SvgPicture.asset(assetNames['doge']!, package: 'crypto_assets');

  static Widget get eth =>
      SvgPicture.asset(assetNames['eth']!, package: 'crypto_assets');

  static Widget get ltc =>
      SvgPicture.asset(assetNames['ltc']!, package: 'crypto_assets');

  static Widget get osmo =>
      SvgPicture.asset(assetNames['osmo']!, package: 'crypto_assets');

  static Widget get polygonMatic =>
      SvgPicture.asset(assetNames['polygon_matic']!, package: 'crypto_assets');

  static Widget get sol =>
      SvgPicture.asset(assetNames['sol']!, package: 'crypto_assets');

  static Widget get sio =>
      SvgPicture.asset(assetNames['sio']!, package: 'crypto_assets');

  static Widget get tetherUsdt =>
      SvgPicture.asset(assetNames['tether']!, package: 'crypto_assets');

  static Widget get usdc =>
      SvgPicture.asset(assetNames['usdc']!, package: 'crypto_assets');

  static Widget get zcashZec =>
      SvgPicture.asset(assetNames['zcash_zec']!, package: 'crypto_assets');

  static Widget get zelFlux =>
      SvgPicture.asset(assetNames['zel_flux']!, package: 'crypto_assets');
}