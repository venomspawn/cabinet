# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о физическом лице

RSpec.describe Cab::API::REST::Individuals::Show do
  describe 'GET /individuals/:id' do
    include described_class::SpecHelper

    subject { get "/individuals/#{id}", params }

    let(:id) { record.id }
    let(:params) { { extended: extended } }
    let(:record) { create(:individual) }
    let!(:identity_documents) { create_list(:identity_document, 2, args) }
    let(:args) { { individual_id: id } }
    let(:extended) { nil }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `show` function of Cab::Actions::Individuals' do
      expect(Cab::Actions::Individuals).to receive(:show)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }
      let!(:identity_documents) {}
      let(:extended) { nil }

      it { is_expected.to be_not_found }
    end
  end
end
