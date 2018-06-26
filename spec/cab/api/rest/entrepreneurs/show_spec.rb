# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о индивидуальном
# предпринимателе

RSpec.describe Cab::API::REST::Entrepreneurs::Show do
  describe 'GET /entrepreneurs/:id' do
    include described_class::SpecHelper

    subject { get "/entrepreneurs/#{id}", params }

    let(:id) { record.id }
    let(:params) { { extended: extended } }
    let(:record) { create(:entrepreneur) }
    let!(:identity_documents) { create_list(:identity_document, 2, args) }
    let(:args) { { individual_id: record.individual_id } }
    let(:extended) { nil }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `show` function of Cab::Actions::Entrepreneurs' do
      expect(Cab::Actions::Entrepreneurs).to receive(:show)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end
  end
end
