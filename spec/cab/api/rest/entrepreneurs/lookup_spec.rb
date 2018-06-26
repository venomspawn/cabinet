# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о индивидуальных ш
# предпринимателях

RSpec.describe Cab::API::REST::Entrepreneurs::Lookup do
  describe 'GET /entrepreneurs' do
    include described_class::SpecHelper

    subject { get '/entrepreneurs', params }

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
      let(:lookup_data) { { first_name: first_name } }
      let(:first_name) { create(:string) }
      let!(:exact) { create_entrepreneurs(2, name: first_name) }
      let!(:other) { create_entrepreneurs(2) }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `lookup` function of Cab::Actions::Entrepreneurs' do
        expect(Cab::Actions::Entrepreneurs).to receive(:lookup)
        subject
      end

      context 'when `lookup_data` is a JSON-string of wrong structure' do
        let(:lookup_data) { %w[wrong structure] }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
