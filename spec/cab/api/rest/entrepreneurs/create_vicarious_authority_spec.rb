# frozen_string_literal: true

# Тестирование метода REST API, создающего записи связей между записями
# индивидуальных предпринимателей, их представителей и документов,
# подтверждающих личность представителей

RSpec.describe Cab::API::REST::Entrepreneurs::CreateVicariousAuthority do
  describe 'POST /entrepreneurs/:id/vicarious_authority' do
    include described_class::SpecHelper

    subject { post "/entrepreneurs/#{id}/vicarious_authority", request_body }

    let(:id) { record.id }
    let(:record) { create(:entrepreneur) }
    let(:request_body) { Oj.dump(params) }
    let(:factory) { 'params/actions/entrepreneurs/create_vicarious_authority' }
    let(:params) { create(factory, traits) }
    let(:traits) { {} }

    it { is_expected.to be_created }

    it { is_expected.to have_proper_body(schema) }

    it 'should call corresponding function of Cab::Actions::Entrepreneurs' do
      expect(Cab::Actions::Entrepreneurs)
        .to receive(:create_vicarious_authority)
      subject
    end

    context 'when the record of entrepreneur isn\'t found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end

    context 'when the record of spokesman isn\'t found' do
      let(:traits) { { id: create(:uuid) } }

      it { is_expected.to be_not_found }
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
