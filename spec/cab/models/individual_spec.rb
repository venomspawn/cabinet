# frozen_string_literal: true

# Тестирование модели записи физического лица

RSpec.describe Cab::Models::Individual do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:individual).except(:id) }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:individual) }

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

      let(:params) { attributes_for(:individual) }

      it { is_expected.to be_a(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:individual) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `params` doesn\'t contain `id` attribute' do
      let(:params) { attributes_for(:individual).except(:id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      context 'when value of `id` property is nil' do
        let(:params) { attributes_for(:individual, id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `id` property is of String' do
        context 'when the value is not of UUID format' do
          let(:params) { attributes_for(:individual, id: value) }
          let(:value) { 'not of UUID format' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `name` property is nil' do
        let(:params) { attributes_for(:individual, name: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `surname` property is nil' do
        let(:params) { attributes_for(:individual, surname: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `birth_place` property is nil' do
        let(:params) { attributes_for(:individual, birth_place: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `birthday` property is nil' do
        let(:params) { attributes_for(:individual, birthday: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `birthday` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:individual, birthday: value) }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `sex` property is nil' do
        let(:params) { attributes_for(:individual, sex: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `sex` property is of String' do
        context 'when the value is not `male` nor `female`' do
          let(:params) { attributes_for(:individual, sex: value) }
          let(:value) { 'not `male` nor `female`' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `citizenship` property is nil' do
        let(:params) { attributes_for(:individual, citizenship: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `citizenship` property is of String' do
        context 'when the value is not `russian`, `foreigner` nor `absent`' do
          let(:params) { attributes_for(:individual, citizenship: value) }
          let(:value) { '`russian`, `foreigner` nor `absent`' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `snils` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:individual, snils: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `inn` property is of String' do
        context 'when the value isn\'t of proper format' do
          let(:params) { attributes_for(:individual, inn: value) }
          let(:value) { 'isn\'t of proper format' }

          it 'should raise Sequel::CheckConstraintViolation' do
            expect { subject }.to raise_error(Sequel::CheckConstraintViolation)
          end
        end
      end

      context 'when value of `residence_address` property is nil' do
        let(:params) { attributes_for(:individual, residence_address: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `agreement` property is nil' do
        let(:params) { attributes_for(:individual, agreement: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is nil' do
        let(:params) { attributes_for(:individual, created_at: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is of String' do
        context 'when the value is not a time\'s representation' do
          let(:params) { attributes_for(:individual, traits) }
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
    subject { create(:individual) }

    methods = %i[
      id
      name
      surname
      middle_name
      birth_place
      birthday
      sex
      citizenship
      snils
      inn
      registration_address
      residence_address
      temp_residence_address
      agreement
      created_at
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        expect(subject).to match /^\d{8}-\d{4}-\d{4}-\d{4}-\d{12}$/
      end
    end
  end

  describe '#name' do
    subject(:result) { instance.name }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#surname' do
    subject(:result) { instance.surname }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#middle_name' do
    subject(:result) { instance.middle_name }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when `middle_name` field is NULL' do
        let(:instance) { create(:individual, middle_name: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `middle_name` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#birth_place' do
    subject(:result) { instance.birth_place }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#birthday' do
    subject(:result) { instance.birthday }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Date) }
    end
  end

  describe '#sex' do
    subject(:result) { instance.sex }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      context 'when `sex` field is `male`' do
        let(:instance) { create(:individual, sex: 'male') }

        it { is_expected.to be == 'male' }
      end

      context 'when `sex` field is `female`' do
        let(:instance) { create(:individual, sex: 'female') }

        it { is_expected.to be == 'female' }
      end
    end
  end

  describe '#citizenship' do
    subject(:result) { instance.citizenship }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      context 'when `citizenship` field is `russian`' do
        let(:instance) { create(:individual, citizenship: 'russian') }

        it { is_expected.to be == 'russian' }
      end

      context 'when `citizenship` field is `foreigner`' do
        let(:instance) { create(:individual, citizenship: 'foreigner') }

        it { is_expected.to be == 'foreigner' }
      end

      context 'when `citizenship` field is `absent`' do
        let(:instance) { create(:individual, citizenship: 'absent') }

        it { is_expected.to be == 'absent' }
      end
    end
  end

  describe '#snils' do
    subject(:result) { instance.snils }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when `snils` field is NULL' do
        let(:instance) { create(:individual, snils: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `snils` field isn\'t NULL' do
        it { is_expected.to be_a(String) }

        it 'should satisfy the format' do
          expect(subject).to match /^\d{3}-\d{3}-\d{3} \d{2}$/
        end
      end
    end
  end

  describe '#inn' do
    subject(:result) { instance.inn }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when `inn` field is NULL' do
        let(:instance) { create(:individual, inn: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `inn` field isn\'t NULL' do
        it { is_expected.to be_a(String) }

        it 'should satisfy the format' do
          expect(subject).to match /^\d{12}$/
        end
      end
    end
  end

  describe '#registration_address' do
    subject(:result) { instance.registration_address }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when `registration_address` field is NULL' do
        let(:instance) { create(:individual, registration_address: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `registration_address` field isn\'t NULL' do
        it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
      end
    end
  end

  describe '#residence_address' do
    subject(:result) { instance.residence_address }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
    end
  end

  describe '#temp_residence_address' do
    subject(:result) { instance.temp_residence_address }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when `temp_residence_address` field is NULL' do
        let(:instance) { create(:individual, temp_residence_address: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `temp_residence_address` field isn\'t NULL' do
        it { is_expected.to respond_to(:to_a) | respond_to(:to_hash) }
      end
    end
  end

  describe '#agreement' do
    subject(:result) { instance.agreement }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:individual) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:individual) }

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

    context 'when `surname` property is present in parameters' do
      let(:params) { { surname: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `surname` attribute of the instance to the value' do
          expect { subject }.to change { instance.surname }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `middle_name` property is present in parameters' do
      let(:params) { { middle_name: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `middle_name` attribute of the instance to the value' do
          expect { subject }.to change { instance.middle_name }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `middle_name` attribute of the instance to nil' do
          expect { subject }.to change { instance.middle_name }.to(nil)
        end
      end
    end

    context 'when `birth_place` property is present in parameters' do
      let(:params) { { birth_place: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `birth_place` attribute of the instance to the value' do
          expect { subject }.to change { instance.birth_place }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `birthday` property is present in parameters' do
      let(:params) { { birthday: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `birthday` attribute of the instance to the date' do
            expect { subject }.to change { instance.birthday }.to(date)
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

        it 'should set `birthday` attribute of the instance to the value' do
          expect { subject }.to change { instance.birthday }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `sex` property is present in parameters' do
      let(:params) { { sex: value } }

      context 'when the value is of String' do
        context 'when the value is `male`' do
          let(:value) { 'male' }
          let(:instance) { create(:individual, sex: 'female') }

          it 'should set `sex` attribute of the instance to the value' do
            expect { subject }.to change { instance.sex }.to(value)
          end
        end

        context 'when the value is `female`' do
          let(:value) { 'female' }
          let(:instance) { create(:individual, sex: 'male') }

          it 'should set `sex` attribute of the instance to the value' do
            expect { subject }.to change { instance.sex }.to(value)
          end
        end

        context 'when the value is not `male` nor `female`' do
          let(:value) { 'not `male` nor `female`' }

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

    context 'when `citizenship` property is present in parameters' do
      let(:params) { { citizenship: value } }

      context 'when the value is of String' do
        context 'when the value is `russian`' do
          let(:value) { 'russian' }
          let(:instance) { create(:individual, citizenship: 'absent') }

          it 'should set `citizenship` attribute to the value' do
            expect { subject }.to change { instance.citizenship }.to(value)
          end
        end

        context 'when the value is `foreigner`' do
          let(:value) { 'foreigner' }
          let(:instance) { create(:individual, citizenship: 'absent') }

          it 'should set `citizenship` attribute to the value' do
            expect { subject }.to change { instance.citizenship }.to(value)
          end
        end

        context 'when the value is `absent`' do
          let(:value) { 'absent' }
          let(:instance) { create(:individual, citizenship: 'foreigner') }

          it 'should set `citizenship` attribute to the value' do
            expect { subject }.to change { instance.citizenship }.to(value)
          end
        end

        context 'when the value is not `russian`, `foreigner` nor `absent`' do
          let(:value) { '`russian`, `foreigner` nor `absent`' }

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

    context 'when `snils` property is present in parameters' do
      let(:params) { { snils: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:snils) }

          it 'should set `snils` attribute of the instance to the value' do
            expect { subject }.to change { instance.snils }.to(value)
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

        it 'should set `snils` attribute of the instance to nil' do
          expect { subject }.to change { instance.snils }.to(nil)
        end
      end
    end

    context 'when `inn` property is present in parameters' do
      let(:params) { { inn: value } }

      context 'when the value is of String' do
        context 'when the value is of proper format' do
          let(:value) { create(:string, length: 12) }

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

        it 'should set `inn` attribute of the instance to nil' do
          expect { subject }.to change { instance.inn }.to(nil)
        end
      end
    end

    context 'when `registration_address` property is present in parameters' do
      let(:params) { { registration_address: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `registration_address` attribute to the value' do
          expect { subject }
            .to change { instance.registration_address }
            .to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `registration_address` attribute to the value' do
          expect { subject }
            .to change { instance.registration_address }
            .to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `registration_address` attribute to nil' do
          expect { subject }
            .to change { instance.registration_address }
            .to(nil)
        end
      end
    end

    context 'when `residence_address` property is present in parameters' do
      let(:params) { { residence_address: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `residence_address` attribute to the value' do
          expect { subject }.to change { instance.residence_address }.to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `residence_address` attribute to the value' do
          expect { subject }.to change { instance.residence_address }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `temp_residence_address` property is present' do
      let(:params) { { temp_residence_address: value } }

      context 'when the value is of Array' do
        let(:value) { create_list(:string, 2) }

        it 'should set `temp_residence_address` attribute to the value' do
          expect { subject }
            .to change { instance.temp_residence_address }
            .to(value)
        end
      end

      context 'when the value is of Hash' do
        let(:value) { create(:address) }

        it 'should set `temp_residence_address` attribute to the value' do
          expect { subject }
            .to change { instance.temp_residence_address }
            .to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `temp_residence_address` attribute to nil' do
          expect { subject }
            .to change { instance.temp_residence_address }
            .to(nil)
        end
      end
    end

    context 'when `agreement` property is present in parameters' do
      let(:params) { { agreement: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `agreement` attribute of the instance to the value' do
          expect { subject }.to change { instance.agreement }.to(value)
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
