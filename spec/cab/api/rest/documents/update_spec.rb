# frozen_string_literal: true

# Тестирование метода REST API, обновляющего содержимое файла документа,
# удостоверяющего личность

RSpec.describe Cab::API::REST::Documents::Update do
  describe 'PUT /documents/:id' do
    subject { put "/documents/#{id}", request_body }

    let(:request_body) { create(:string) }
    let(:id) { record.id }
    let(:record) { create(:identity_document) }

    it { is_expected.to be_no_content }

    it 'should call `update` function of Cab::Actions::Documents' do
      expect(Cab::Actions::Documents).to receive(:update)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end
  end
end
