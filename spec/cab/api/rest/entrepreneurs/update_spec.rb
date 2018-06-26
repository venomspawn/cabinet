# frozen_string_literal: true

# Тестирование метода REST API, обновляющего поля записей индивидуальных
# предпринимателей

RSpec.describe Cab::API::REST::Entrepreneurs::Update do
  describe 'PUT /entrepreneurs/:id' do
    include described_class::SpecHelper

    subject { put "/entrepreneurs/#{id}", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:entrepreneur) }
    let(:params) { create('params/actions/entrepreneurs/update') }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `update` function of Cab::Actions::Entrepreneurs' do
      expect(Cab::Actions::Entrepreneurs).to receive(:update)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end

    context 'when request body is a JSON-string' do
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
