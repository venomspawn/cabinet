# frozen_string_literal: true

# Тестирование метода REST API, возвращающего информацию о физических лицах

RSpec.describe Cab::API::REST::Individuals::Lookup do
  describe 'GET /individuals' do
    include described_class::SpecHelper

    subject { get '/individuals', params }

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
      let!(:exact) { create_list(:individual, 2, name: first_name) }
      let!(:other) { create_list(:individual, 2) }

      it { is_expected.to be_ok }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `lookup` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:lookup)
        subject
      end

      context 'when `lookup_data` is a JSON-string of wrong structure' do
        let(:lookup_data) { %w[wrong structure] }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
