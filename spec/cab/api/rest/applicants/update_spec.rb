# frozen_string_literal: true

# Тестирование метода REST API, обновляющего поля записей заявителей

RSpec.describe Cab::API::REST::Applicants::Update do
  describe 'PUT /applicants/:id' do
    include described_class::SpecHelper

    subject { put "/applicants/#{id}", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:individual) }

    context 'when updating a record of individual' do
      let(:record) { create(:individual) }
      let(:params) { { individual: data } }
      let(:data) { create('params/actions/individuals/update') }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `update` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:update)
        subject
      end

      context 'when the record can\'t be found' do
        let(:id) { create(:uuid) }

        it { is_expected.to be_not_found }
      end
    end

    context 'when updating a record of entrepreneur' do
      let(:record) { create(:entrepreneur) }
      let(:params) { { entrepreneur: data } }
      let(:data) { create('params/actions/entrepreneurs/update') }

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
    end

    context 'when updating a record of organization' do
      let(:record) { create(:organization) }
      let(:params) { { organization: data } }
      let(:data) { create('params/actions/organizations/update') }

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
