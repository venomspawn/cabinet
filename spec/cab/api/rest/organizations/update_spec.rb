# frozen_string_literal: true

# Тестирование метода REST API, обновляющего поля записей юридических лиц

RSpec.describe Cab::API::REST::Organizations::Update do
  describe 'PUT /organizations/:id' do
    include described_class::SpecHelper

    subject { put "/organizations/#{id}", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:organization) }
    let(:params) { create('params/actions/organizations/update') }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `update` function of Cab::Actions::Organizations' do
      expect(Cab::Actions::Organizations).to receive(:update)
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
