# frozen_string_literal: true

# Тестирование модели записи организаций

RSpec.describe Cab::Models::Organization do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:organization).except(:id) }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:organization) }

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

      let(:params) { attributes_for(:organization) }

      it { is_expected.to be_a(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:organization) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `params` doesn\'t contain `id` attribute' do
      let(:params) { attributes_for(:organization).except(:id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      context 'when value of `id` property is nil' do
        let(:params) { attributes_for(:organization, id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `id` property is of String' do
        context 'when the value is not of UUID format' do
          let(:params) { attributes_for(:organization, id: value) }
          let(:value) { 'not of UUID format' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `full_name` property is nil' do
        let(:params) { attributes_for(:organization, full_name: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `director` property is nil' do
        let(:params) { attributes_for(:organization, director: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `registration_date` property is nil' do
        let(:params) { attributes_for(:organization, traits) }
        let(:traits) { { registration_date: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `registration_date` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:organization, traits) }
          let(:traits) { { registration_date: value } }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `inn` property is nil' do
        let(:params) { attributes_for(:organization, inn: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `inn` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:organization, inn: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `kpp` property is nil' do
        let(:params) { attributes_for(:organization, kpp: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `kpp` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:organization, kpp: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `ogrn` property is nil' do
        let(:params) { attributes_for(:organization, ogrn: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `ogrn` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:organization, ogrn: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `legal_address` property is nil' do
        let(:params) { attributes_for(:organization, legal_address: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is nil' do
        let(:params) { attributes_for(:organization, created_at: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is of String' do
        context 'when the value is not a time\'s representation' do
          let(:params) { attributes_for(:organization, traits) }
          let(:traits) { { created_at: value } }
          let(:value) { 'not a time\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end
    end
  end

  describe 'an instance' do
    subject { create(:organization) }

    methods = %i[
      id
      full_name
      short_name
      director
      registration_date
      inn
      kpp
      ogrn
      legal_address
      actual_address
      bank_details
      created_at
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        expect(subject).to match /^\d{8}-\d{4}-\d{4}-\d{4}-\d{12}$/
      end
    end
  end

  describe '#full_name' do
    subject(:result) { instance.full_name }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#short_name' do
    subject(:result) { instance.short_name }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      context 'when `short_name` field is NULL' do
        let(:instance) { create(:organization, short_name: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `short_name` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#director' do
    subject(:result) { instance.director }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#registration_date' do
    subject(:result) { instance.registration_date }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Date) }
    end
  end

  describe '#inn' do
    subject(:result) { instance.inn }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should satisfy the format' do
        expect(subject).to match /^\d{10}$/
      end
    end
  end

  describe '#kpp' do
    subject(:result) { instance.kpp }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should satisfy the format' do
        expect(subject).to match /^\d{9}$/
      end
    end
  end

  describe '#ogrn' do
    subject(:result) { instance.ogrn }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should satisfy the format' do
        expect(subject).to match /^\d{13}$/
      end
    end
  end

  describe '#legal_address' do
    subject(:result) { instance.legal_address }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
    end
  end

  describe '#actual_address' do
    subject(:result) { instance.actual_address }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      context 'when `actual_address` field is NULL' do
        let(:instance) { create(:organization, actual_address: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `actual_address` field isn\'t NULL' do
        it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
      end
    end
  end

  describe '#bank_details' do
    subject(:result) { instance.bank_details }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      context 'when `bank_details` field is NULL' do
        let(:instance) { create(:organization, bank_details: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `bank_details` field isn\'t NULL' do
        it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
      end
    end
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:organization) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:organization) }

    context 'when `id` property is present in parameters' do
      let(:params) { { id: value } }
      let(:value) { create(:uuid) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `full_name` property is present in parameters' do
      let(:params) { { full_name: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `full_name` attribute of the instance to the value' do
          expect { subject }.to change { instance.full_name }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `short_name` property is present in parameters' do
      let(:params) { { short_name: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `short_name` attribute of the instance to the value' do
          expect { subject }.to change { instance.short_name }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `short_name` attribute of the instance to nil' do
          expect { subject }.to change { instance.short_name }.to(nil)
        end
      end
    end

    context 'when `director` property is present in parameters' do
      let(:params) { { director: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `director` attribute of the instance to the value' do
          expect { subject }.to change { instance.director }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `registration_date` property is present in parameters' do
      let(:params) { { registration_date: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `registration_date` attribute to the date' do
            expect { subject }
              .to change { instance.registration_date }
              .to(date)
          end
        end

        context 'when the value is not a date\'s representation' do
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when the value is of Date' do
        let(:value) { create(:date) }

        it 'should set `registration_date` attribute to the value' do
          expect { subject }.to change { instance.registration_date }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `inn` property is present in parameters' do
      let(:params) { { inn: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:string, length: 10) }

          it 'should set `inn` attribute of the instance to the value' do
            expect { subject }.to change { instance.inn }.to(value)
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

    context 'when `kpp` property is present in parameters' do
      let(:params) { { kpp: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:string, length: 9) }

          it 'should set `kpp` attribute of the instance to the value' do
            expect { subject }.to change { instance.kpp }.to(value)
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

    context 'when `ogrn` property is present in parameters' do
      let(:params) { { ogrn: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:string, length: 13) }

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

    context 'when `legal_address` property is present in parameters' do
      let(:params) { { legal_address: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `legal_address` attribute to the value' do
          expect { subject }.to change { instance.legal_address }.to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `legal_address` attribute to the value' do
          expect { subject }.to change { instance.legal_address }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
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

        it 'should set `actual_address` attribute to nil' do
          expect { subject }.to change { instance.actual_address }.to(nil)
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

    context 'when `created_at` property is present in parameters' do
      let(:params) { { created_at: value } }

      context 'when the value is of String' do
        context 'when the value is a time\'s representation' do
          before { subject }

          let(:value) { created_at.to_s }
          let(:created_at) { Time.now - 1 }

          it 'should set `created_at` attribute to the date' do
            expect(instance.created_at).to be_within(1).of(created_at)
          end
        end

        context 'when the value is not a time\'s representation' do
          let(:value) { 'not a time\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when the value is of Time' do
        before { subject }

        let(:value) { Time.now - 1 }

        it 'should set `created_at` attribute to the value' do
          expect(instance.created_at).to be_within(1).of(value)
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
