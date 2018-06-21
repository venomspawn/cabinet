# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о заявителях

RSpec.describe Cab::API::REST::Applicants::Lookup do
  describe 'GET /applicants' do
    include described_class::SpecHelper

    subject { get '/applicants', params }

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

      context 'when looking for individuals' do
        let(:lookup_data) { { individual: { first_name: first_name } } }
        let(:first_name) { create(:string) }
        let!(:exact) { create_list(:individual, 2, name: first_name) }
        let!(:other) { create_list(:individual, 2) }

        it { is_expected.to be_ok }

        it { is_expected.to have_proper_body(schema) }
      end

      context 'when looking for entrepreneurs' do
        let(:lookup_data) { { entrepreneur: { first_name: first_name } } }
        let(:first_name) { create(:string) }
        let!(:exact) { create_entrepreneurs(2, name: first_name) }
        let!(:other) { create_entrepreneurs(2) }

        it { is_expected.to be_ok }

        it { is_expected.to have_proper_body(schema) }
      end

      context 'when looking for organizations' do
        let(:lookup_data) { { organization: { full_name: full_name } } }
        let(:full_name) { create(:string) }
        let!(:exact) { create_list(:organization, 2, full_name: full_name) }
        let!(:other) { create_list(:organization, 2) }

        it { is_expected.to be_ok }

        it { is_expected.to have_proper_body(schema) }
      end

      context 'when `lookup_data` is a JSON-string of wrong structure' do
        let(:lookup_data) { %w[wrong structure] }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
