# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о юридических лицах

RSpec.describe Cab::API::REST::Organizations::Lookup do
  describe 'GET /organizations' do
    include described_class::SpecHelper

    subject { get '/organizations', params }

    context 'when params doesn\'t contain `lookup_data` property' do
      let(:params) { {} }

      it { is_expected.to be_unprocessable }
    end

    context 'when `lookup_data` property of params is not a JSON-string' do
      let(:params) { { lookup_data: 'not a JSON-string' } }

      it { is_expected.to be_unprocessable }
    end

    context 'when `lookup_data` property of params is a JSON-string' do
      let(:params) { { lookup_data: Oj.dump(lookup_data) } }
      let(:lookup_data) { { full_name: full_name } }
      let(:full_name) { create(:string) }
      let!(:exact) { create_list(:organization, 2, full_name: full_name) }
      let!(:other) { create_list(:organization, 2) }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `lookup` function of Cab::Actions::Organizations' do
        expect(Cab::Actions::Organizations).to receive(:lookup)
        subject
      end

      context 'when `lookup_data` is a JSON-string of wrong structure' do
        let(:lookup_data) { %w[wrong structure] }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
