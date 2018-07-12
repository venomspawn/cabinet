# frozen_string_literal: true

# Тестирование модели записи документа, подтверждающего полномочия
# представителя

RSpec.describe Cab::Models::VicariousAuthority do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:vicarious_authority).except(:id) }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:vicarious_authority) }

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

      let(:params) { attributes_for(:vicarious_authority) }

      it { is_expected.to be_a(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:vicarious_authority) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `params` doesn\'t contain `id` attribute' do
      let(:params) { attributes_for(:vicarious_authority).except(:id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      context 'when value of `id` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `id` property is of String' do
        context 'when the value is not of UUID format' do
          let(:params) { attributes_for(:vicarious_authority, id: value) }
          let(:value) { 'not of UUID format' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `name` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, name: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issued_by` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, issued_by: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issue_date` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, issue_date: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issue_date` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:vicarious_authority, traits) }
          let(:traits) { { issue_date: value } }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `expiration_date` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:vicarious_authority, traits) }
          let(:traits) { { expiration_date: value } }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `content` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, content: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is nil' do
        let(:params) { attributes_for(:vicarious_authority, traits) }
        let(:traits) { { created_at: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is of String' do
        context 'when the value is not a time\'s representation' do
          let(:params) { attributes_for(:vicarious_authority, traits) }
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
    subject { create(:vicarious_authority) }

    methods = %i[
      id
      name
      number
      series
      registry_number
      issued_by
      issue_date
      expiration_date
      created_at
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        hex = '[0-9a-fA-F]'
        expect(subject)
          .to match(/^#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}$/)
      end
    end
  end

  describe '#name' do
    subject(:result) { instance.name }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#number' do
    subject(:result) { instance.number }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      context 'when `number` field is NULL' do
        let(:instance) { create(:vicarious_authority, number: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `number` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#series' do
    subject(:result) { instance.series }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      context 'when `series` field is NULL' do
        let(:instance) { create(:vicarious_authority, series: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `series` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#registry_number' do
    subject(:result) { instance.registry_number }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      context 'when `registry_number` field is NULL' do
        let(:instance) { create(:vicarious_authority, registry_number: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `registry_number` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#issued_by' do
    subject(:result) { instance.issued_by }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#issue_date' do
    subject(:result) { instance.issue_date }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Date) }
    end
  end

  describe '#expiration_date' do
    subject(:result) { instance.expiration_date }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      context 'when `expiration_date` field is NULL' do
        let(:instance) { create(:vicarious_authority, expiration_date: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `expiration_date` field isn\'t NULL' do
        it { is_expected.to be_a(Date) }
      end
    end
  end

  describe '#content' do
    subject(:result) { instance.content }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:vicarious_authority) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:vicarious_authority) }

    context 'when `id` property is present in parameters' do
      let(:params) { { id: value } }
      let(:value) { create(:uuid) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `name` property is present in parameters' do
      let(:params) { { name: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `name` attribute of the instance to the value' do
          expect { subject }.to change { instance.name }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `number` property is present in parameters' do
      let(:params) { { number: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `number` attribute of the instance to the value' do
          expect { subject }.to change { instance.number }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `number` attribute of the instance to nil' do
          expect { subject }.to change { instance.number }.to(nil)
        end
      end
    end

    context 'when `series` property is present in parameters' do
      let(:params) { { series: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `series` attribute of the instance to the value' do
          expect { subject }.to change { instance.series }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `series` attribute of the instance to nil' do
          expect { subject }.to change { instance.series }.to(nil)
        end
      end
    end

    context 'when `registry_number` property is present in parameters' do
      let(:params) { { registry_number: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `registry_number` attribute to the value' do
          expect { subject }.to change { instance.registry_number }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `registry_number` attribute of the instance to nil' do
          expect { subject }.to change { instance.registry_number }.to(nil)
        end
      end
    end

    context 'when `issued_by` property is present in parameters' do
      let(:params) { { issued_by: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `issued_by` attribute of the instance to the value' do
          expect { subject }.to change { instance.issued_by }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `issue_date` property is present in parameters' do
      let(:params) { { issue_date: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `issue_date` attribute to the date' do
            expect { subject }.to change { instance.issue_date }.to(date)
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

        it 'should set `issue_date` attribute to the value' do
          expect { subject }.to change { instance.issue_date }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `expiration_date` property is present in parameters' do
      let(:params) { { expiration_date: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `expiration_date` attribute to the date' do
            expect { subject }.to change { instance.expiration_date }.to(date)
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

        it 'should set `expiration_date` attribute to the value' do
          expect { subject }.to change { instance.expiration_date }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `expiration_date` attribute of the instance to nil' do
          expect { subject }.to change { instance.expiration_date }.to(nil)
        end
      end
    end

    context 'when `content` property is present in parameters' do
      let(:params) { { content: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `content` attribute of the instance to the value' do
          expect { subject }.to change { instance.content }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
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
