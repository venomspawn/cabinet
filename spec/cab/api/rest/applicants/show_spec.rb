# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о заявителе

RSpec.describe Cab::API::REST::Applicants::Show do
  describe 'GET /applicants/:id' do
    include described_class::SpecHelper

    subject { get "/applicants/#{id}", params }

    let(:id) { record.id }
    let(:params) { { extended: extended } }

    context 'when looking for a record of individual' do
      let(:record) { create(:individual) }
      let!(:identity_documents) { create_list(:identity_document, 2, args) }
      let(:args) { { individual_id: id } }
      let(:extended) { false }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }
    end

    context 'when looking for a record of entrepreneur' do
      let(:record) { create(:entrepreneur) }
      let!(:identity_documents) { create_list(:identity_document, 2, args) }
      let(:args) { { individual_id: record.individual_id } }
      let(:extended) { false }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }
    end

    context 'when looking for a record of entrepreneur' do
      let(:record) { create(:organization) }
      let(:extended) { nil }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }
      let(:extended) { nil }

      it { is_expected.to be_not_found }
    end
  end
end
