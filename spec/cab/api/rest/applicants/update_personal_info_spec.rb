# frozen_string_literal: true

# Тестирование метода REST API, обновляющего персональные данные в записях
# заявителей

RSpec.describe Cab::API::REST::Applicants::UpdatePersonalInfo do
  describe 'PUT /applicants/:id/personal' do
    include described_class::SpecHelper

    subject { put "/applicants/#{id}/personal", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:individual) }

    context 'when updating a record of individual' do
      let(:record) { create(:individual) }
      let(:params) { { individual: data } }
      let(:factory) { 'params/actions/individuals/update_personal_info' }
      let(:data) { create(factory) }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call corresponding function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:update_personal_info)
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
      let(:factory) { 'params/actions/entrepreneurs/update_personal_info' }
      let(:data) { create(factory) }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call corresponding function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Entrepreneurs).to receive(:update_personal_info)
        subject
      end

      context 'when the record can\'t be found' do
        let(:id) { create(:uuid) }

        it { is_expected.to be_not_found }
      end
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
