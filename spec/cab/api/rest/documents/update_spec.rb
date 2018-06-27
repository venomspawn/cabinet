# frozen_string_literal: true

# Тестирование метода REST API, обновляющего содержимое файла документа,
# удостоверяющего личность

RSpec.describe Cab::API::REST::Documents::Update do
  describe 'PUT /documents/:id' do
    subject { put "/documents/#{id}", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:identity_document) }
    let(:params) { create('params/actions/documents/update') }

    it { is_expected.to be_no_content }

    it 'should call `update` function of Cab::Actions::Documents' do
      expect(Cab::Actions::Documents).to receive(:update)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end

    context 'when request body is a JSON-string' do
      context 'when params represents a map' do
        context 'when the map is of wrong structure' do
          let(:request_body) { Oj.dump(wrong: :structure) }

          it { is_expected.to be_unprocessable }
        end
      end

      context 'when params does not represent a map' do
        let(:request_body) { Oj.dump(%i[not a map]) }

        it { is_expected.to be_unprocessable }
      end
    end

    context 'when params is not a JSON-string' do
      let(:request_body) { 'not a JSON-string' }

      it { is_expected.to be_unprocessable }
    end
  end
end
