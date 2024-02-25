require 'net/http'

module Moderable
  extend ActiveSupport::Concern

  included do
    before_save :moderate_content
  end

  def moderate_content
    # Accéder aux valeurs des colonnes spécifiées
    text_to_moderate = self.text
    language_using_to_moderate = self.language

    # Code pour appeler l'API de modération et stocker le résultat dans is_accepted
    url = URI("https://moderation.logora.fr/predict?text=#{URI.encode_www_form_component(text_to_moderate)}&language=#{URI.encode_www_form_component(language_using_to_moderate)}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["Content-Type"] = 'multipart/form-data; boundary=---011000010111000001101001'
    request["User-Agent"] = 'insomnia/8.6.1'

    response = http.request(request)
    prediction = (JSON.parse(response.read_body)["prediction"]["0"])

    self.is_accepted = prediction < 0.98

    puts "============================================Prediction: #{prediction}"
    puts "============================================Is accepted: #{self.is_accepted}"
  end
end

class ModeratedModel < ApplicationRecord
  include Moderable
end
