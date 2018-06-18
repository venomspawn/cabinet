# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о версии сервиса

RSpec.describe Cab::API::REST::Version::Show do
  describe 'GET /version' do
    include described_class::SpecHelper

    subject { get '/version' }

    it { is_expected.to be_ok }
    it { is_expected.to have_proper_body(schema) }
  end
end
