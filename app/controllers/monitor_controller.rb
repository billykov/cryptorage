class MonitorController < ApplicationController
  require 'cryptsy/api'
  include HTTParty
  before_filter :set_currencies
  before_filter :set_vos_client

  base_uri 'coinmarketcap-nexuist.rhcloud.com'


  def show
    cryptsy = get_cryptsy_data



    @ticker = {}
    @currencies.each do |currency|
      @ticker[currency] = {}

      @ticker[currency]['cryptsy'] = cryptsy['return']['markets']["#{currency}/BTC"]['lasttradeprice']

      @ticker[currency]['coinmarketcap'] = get_coinmarketcap_data currency.downcase



      @ticker[currency]['vos'] =
        begin
          vos_currency = get_vos_data currency , 'BTC'
          vos_currency.min_price
        rescue => e
          'N/A' # NO API DATA
        end
    end
    p ' s '
  end

  def set_currencies
    @currencies = ['DOGE', 'DRK', 'POT']
    @conversions = ['DOGE/BTC', 'BTC/DOGE']
  end

  def set_vos_client
    api_key = API_CONF['VOS']['KEY']
    api_secret = API_CONF['VOS']['SECRET']
    @vos = VaultOfSatoshi::API::Client.new(api_key, api_secret)
  end

  def get_cryptsy_data
    Rails.cache.fetch("get_cryptsy_data", :expires_in => 5.minutes) do
      cryptsy = Cryptsy::API::Client.new()
      cryptsy = cryptsy.marketdata
    end
  end

  def get_vos_data currency, to_currency
    Rails.cache.fetch("get_vos_#{currency}", :expires_in => 5.minutes) do
      @vos.info.ticker(order_currency: currency, payment_currency: to_currency)
    end
  end

  def get_coinmarketcap_data currency
    Rails.cache.fetch("get_coinmarketcap_#{currency}", :expires_in => 5.minutes) do
      coinmarketcap = self.class.get("/api/#{currency}").to_hash
    end
  end
end
