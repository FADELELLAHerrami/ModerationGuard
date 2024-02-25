# test/models/moderated_model_test.rb

require "test_helper"
require 'webmock/minitest'

class ModeratedModelTest < ActiveSupport::TestCase
  test 'moderates content before saving' do
    moderated_model = ModeratedModel.new(text: 'Bonjour', language: 'fr-FR')

    # Stub the HTTP request to return a response with a prediction of 0.98
    WebMock.stub_request(:get, "https://moderation.logora.fr/predict?text=Bonjour&language=fr-FR").to_return(body: '{"prediction":{"0":0.98}}')

    # Save the moderated model
    moderated_model.save

    # Check if the is_accepted attribute is set correctly
    assert_equal false, moderated_model.is_accepted
  end
end
