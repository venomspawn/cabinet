# frozen_string_literal: true

# Тестирование метода REST API, создающего запись файла

RSpec.describe Cab::API::REST::Files::Create do
  include described_class::SpecHelper

  describe 'POST /files' do
    subject(:response) { post '/files', payload }

    let(:payload) { create(:string) }

    it 'should call `#create` of Cab::Actions::Files' do
      expect(Cab::Actions::Files).to receive(:create)
      subject
    end

    describe 'response' do
      subject { response }

      it { is_expected.to be_created }

      it { is_expected.to have_proper_body(schema) }
    end
  end
end
