# frozen_string_literal: true

# Тестирование модели записи индивидуального предпринимателя

RSpec.describe Cab::Models::Entrepreneur do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:entrepreneur).except(:id) }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:entrepreneur) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      subject { result }

      let(:params) { attributes_for(:entrepreneur) }

      it { is_expected.to be_a(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:entrepreneur) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `params` doesn\'t contain `id` attribute' do
      let(:params) { attributes_for(:entrepreneur).except(:id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      context 'when value of `id` property is nil' do
        let(:params) { attributes_for(:entrepreneur, id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `id` property is of String' do
        context 'when the value is not of UUID format' do
          let(:params) { attributes_for(:entrepreneur, id: value) }
          let(:value) { 'not of UUID format' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `ogrn` property is nil' do
        let(:params) { attributes_for(:entrepreneur, ogrn: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `ogrn` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:entrepreneur, ogrn: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `actual_address` property is nil' do
        let(:params) { attributes_for(:entrepreneur, actual_address: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `individual_id` property is nil' do
        let(:params) { attributes_for(:entrepreneur, individual_id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `individual_id` property repeats' do
        let(:params) { attributes_for(:entrepreneur, individual_id: value) }
        let(:value) { other_entrepreneur.individual_id }
        let(:other_entrepreneur) { create(:entrepreneur) }

        it 'should raise Sequel::UniqueConstraintViolation' do
          expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
        end
      end

      context 'when value of `individual_id` is not an primary key' do
        let(:params) { attributes_for(:entrepreneur, individual_id: value) }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end
    end
  end

  describe 'an instance' do
    subject { create(:entrepreneur) }

    methods = %i[
      id
      commercial_name
      ogrn
      bank_details
      actual_address
      individual_id
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        expect(subject).to match /^\d{8}-\d{4}-\d{4}-\d{4}-\d{12}$/
      end
    end
  end

  describe '#commercial_name' do
    subject(:result) { instance.commercial_name }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      context 'when `commercial_name` field is NULL' do
        let(:instance) { create(:entrepreneur, commercial_name: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `commercial_name` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#ogrn' do
    subject(:result) { instance.ogrn }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should satisfy the format' do
        expect(subject).to match /^\d{15}$/
      end
    end
  end

  describe '#bank_details' do
    subject(:result) { instance.bank_details }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      context 'when `bank_details` field is NULL' do
        let(:instance) { create(:entrepreneur, bank_details: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `bank_details` field isn\'t NULL' do
        it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
      end
    end
  end

  describe '#actual_address' do
    subject(:result) { instance.actual_address }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
    end
  end

  describe '#individual_id' do
    subject(:result) { instance.individual_id }

    let(:instance) { create(:entrepreneur) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        expect(subject).to match /^\d{8}-\d{4}-\d{4}-\d{4}-\d{12}$/
      end

      let(:individual) { Cab::Models::Individual.where(id: subject).first }

      it 'should be a primary key in the tables of individuals' do
        expect(individual).not_to be_nil
      end
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:entrepreneur) }

    context 'when `id` property is present in parameters' do
      let(:params) { { id: value } }
      let(:value) { create(:uuid) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `commercial_name` property is present in parameters' do
      let(:params) { { commercial_name: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `commercial_name` attribute to the value' do
          expect { subject }.to change { instance.commercial_name }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `commercial_name` attribute of the instance to nil' do
          expect { subject }.to change { instance.commercial_name }.to(nil)
        end
      end
    end

    context 'when `ogrn` property is present in parameters' do
      let(:params) { { ogrn: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:string, length: 15) }

          it 'should set `ogrn` attribute of the instance to the value' do
            expect { subject }.to change { instance.ogrn }.to(value)
          end
        end

        context 'when the value isn\'t of proper format' do
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `bank_details` property is present in parameters' do
      let(:params) { { bank_details: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `bank_details` attribute to the value' do
          expect { subject }.to change { instance.bank_details }.to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `bank_details` attribute to the value' do
          expect { subject }.to change { instance.bank_details }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `bank_details` attribute to nil' do
          expect { subject }.to change { instance.bank_details }.to(nil)
        end
      end
    end

    context 'when `actual_address` property is present in parameters' do
      let(:params) { { actual_address: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `actual_address` attribute to the value' do
          expect { subject }.to change { instance.actual_address }.to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `actual_address` attribute to the value' do
          expect { subject }.to change { instance.actual_address }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `individual_id` property is present in parameters' do
      let(:params) { { individual_id: value } }

      context 'when the value is of String' do
        context 'when the value is an UUID' do
          context 'when the value is not a primary key in individuals table' do
            let(:value) { create(:uuid) }

            it 'should raise Sequel::ForeignKeyConstraintViolation' do
              expect { subject }
                .to raise_error(Sequel::ForeignKeyConstraintViolation)
            end
          end

          context 'when the value is a primary key in individuals table' do
            context 'when the value repeats' do
              let(:value) { other_entrepreneur.individual_id }
              let(:other_entrepreneur) { create(:entrepreneur) }

              it 'should raise Sequel::UniqueConstraintViolation' do
                expect { subject }
                  .to raise_error(Sequel::UniqueConstraintViolation)
              end
            end

            context 'when the value doesn\'t repeat' do
              let(:value) { create(:individual).id }

              it 'should set `individual_id` attribute to the value' do
                expect { subject }
                  .to change { instance.individual_id }
                  .to(value)
              end
            end
          end
        end

        context 'when the value isn\'t an UUID' do
          let(:value) { 'isn\'t an UUID' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end
  end
end