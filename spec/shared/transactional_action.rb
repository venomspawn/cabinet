# frozen_string_literal: true

# Общие тесты действий, проверяющие, что действие создаёт исключение и не
# создаёт записи

RSpec.shared_examples 'a transactional action' do |args|
  error, models = args.values_at(:error, :shouldnt_create)

  it "should raise #{error}" do
    expect { subject }.to raise_error(error)
  end

  models.each do |model|
    model = Cab::Models.const_get(model)
    it "shouldn\'t create records of #{model}" do
      expect { subject }.to raise_error(error).and change { model.count }.by(0)
    end
  end
end
