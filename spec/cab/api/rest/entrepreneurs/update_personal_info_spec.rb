# frozen_string_literal: true

# Тестирование метода REST API, обновляющего персональные данные в записях
# индивидуальных предпринимателей

RSpec.describe Cab::API::REST::Entrepreneurs::UpdatePersonalInfo do
  describe 'PUT /entrepreneurs/:id/personal' do
    include described_class::SpecHelper

    subject { put "/entrepreneurs/#{id}/personal", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:entrepreneur) }
    let(:factory) { 'params/actions/entrepreneurs/update_personal_info' }
    let(:params) { create(factory) }

    it { is_expected.to be_created }

    it { is_expected.to have_proper_body(schema) }

    it 'should call corresponding function of Cab::Actions::Individuals' do
      expect(Cab::Actions::Entrepreneurs).to receive(:update_personal_info)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

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
