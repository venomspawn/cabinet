# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о юридическом лице

RSpec.describe Cab::API::REST::Organizations::Show do
  describe 'GET /organizations/:id' do
    include described_class::SpecHelper

    subject { get "/organizations/#{id}" }

    let(:id) { record.id }
    let(:record) { create(:organization) }

    it { is_expected.to be_ok }

    it { is_expected.to have_proper_body(schema) }

    it 'should call `show` function of Cab::Actions::Organizations' do
      expect(Cab::Actions::Organizations).to receive(:show)
      subject
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it { is_expected.to be_not_found }
    end
  end
end
