# frozen_string_literal: true

# Тестирование метода REST API, обновляющего содержимое файла документа,
# удостоверяющего личность

RSpec.describe Cab::API::REST::Documents::Update do
  describe 'PUT /documents/:id' do
    include described_class::SpecHelper

    subject { put "/documents/#{id}", request_body }

    let(:request_body) { Oj.dump(params) }
    let(:id) { record.id }
    let(:record) { create(:identity_document) }
    let(:params) { create('params/actions/documents/update') }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `update` function of Cab::Actions::Documents' do
      expect(Cab::Actions::Documents).to receive(:update)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end

    context 'when request body is a JSON-string' do
      context 'when params represents a list ' do
        context 'when the list is of wrong structure' do
          let(:request_body) { Oj.dump(%i[wrong structure]) }

          it { is_expected.to be_unprocessable }
        end
      end

      context 'when params does not represent a list ' do
        let(:request_body) { Oj.dump(not: { a: :list }) }

        it { is_expected.to be_unprocessable }
      end
    end

    context 'when params is not a JSON-string' do
      let(:request_body) { 'not a JSON-string' }

      it { is_expected.to be_unprocessable }
    end
  end
end
