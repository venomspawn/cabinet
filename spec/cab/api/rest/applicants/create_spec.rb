# frozen_string_literal: true

# Тестирование метода REST API, создающего записи заявителей

RSpec.describe Cab::API::REST::Applicants::Create do
  describe 'POST /applicants' do
    include described_class::SpecHelper

    subject { post '/applicants', request_body }

    let(:request_body) { Oj.dump(params) }

    context 'when creating a record of individual' do
      let(:params) { { individual: data } }
      let(:data) { create('params/actions/individuals/create', *traits) }
      let(:traits) { [] }

      it { is_expected.to be_created }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `create` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:create)
        subject
      end

      context 'when there is information about spokesman' do
        context 'when the record of spokesman isn\'t found' do
          let(:traits) { [:with_spokesman, spokesman: spokesman] }
          let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

          it { is_expected.to be_not_found }
        end
      end
    end

    context 'when creating a record of entrepreneur' do
      let(:params) { { entrepreneur: data } }
      let(:data) { create('params/actions/entrepreneurs/create', *traits) }
      let(:traits) { %i[with_individual] }

      it { is_expected.to be_created }

      it { is_expected.to have_proper_body(schema) }

      it 'should call `create` function of Cab::Actions::Entrepreneurs' do
        expect(Cab::Actions::Entrepreneurs).to receive(:create)
        subject
      end

      context 'when there is information about spokesman' do
        let(:traits) { %i[with_individual with_spokesman] }

        context 'when the record of spokesman isn\'t found' do
          let(:traits) { [:with_individual, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

          it { is_expected.to be_not_found }
        end
      end

      context 'when information about individual id is provided' do
        context 'when the record of individual isn\'t found' do
          let(:traits) { [:with_individual_id, individual_id: create(:uuid)] }

          it { is_expected.to be_not_found }
        end
      end
    end

    context 'when creating a record of organization' do
      let(:params) { { organization: data } }
      let(:data) { create('params/actions/organizations/create', traits) }
      let(:traits) { {} }

      it { is_expected.to be_created }

      it { is_expected.to have_proper_body(schema) }

      context 'when the record of spokesman isn\'t found' do
        let(:traits) { { spokesman: spokesman } }
        let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

        it { is_expected.to be_not_found }
      end
    end

    context 'when request body is a JSON-string' do
      context 'when request body represents a map' do
        context 'when the map is of wrong structure' do
          let(:request_body) { Oj.dump(wrong: :structure) }

          it { is_expected.to be_unprocessable }
        end
      end

      context 'when params does not represent a map' do
        let(:request_body) { Oj.dump(%w[not a map]) }

        it { is_expected.to be_unprocessable }
      end
    end

    context 'when params is not a JSON-string' do
      let(:request_body) { 'not a JSON-string' }

      it { is_expected.to be_unprocessable }
    end
  end
end
