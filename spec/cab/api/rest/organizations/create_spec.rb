# frozen_string_literal: true

# Тестирование метода REST API, создающего записи юридических лиц

RSpec.describe Cab::API::REST::Organizations::Create do
  describe 'POST /organizations' do
    include described_class::SpecHelper

    subject { post '/organizations', request_body }

    let(:request_body) { Oj.dump(params) }
    let(:params) { create('params/actions/organizations/create', traits) }
    let(:traits) { {} }

    it { is_expected.to be_created }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `create` function of Cab::Actions::Organizations' do
      expect(Cab::Actions::Organizations).to receive(:create)
      subject
    end

    context 'when the record of spokesman isn\'t found' do
      let(:traits) { { spokesman: spokesman } }
      let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

      it { is_expected.to be_unprocessable }
    end

    context 'when request body is a JSON-string' do
      context 'when request body represents a map' do
        context 'when the map is of wrong structure' do
          let(:request_body) { Oj.dump(wrong: :structure) }

          it { is_expected.to be_unprocessable }
        end
      end

      context 'when params does not represent a map' do
        let(:request_body) { Oj.dump(%w[not a map]) }

        it { is_expected.to be_unprocessable }
      end
    end

    context 'when params is not a JSON-string' do
      let(:request_body) { 'not a JSON-string' }

      it { is_expected.to be_unprocessable }
    end
  end
end
