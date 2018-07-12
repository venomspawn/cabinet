# frozen_string_literal: true

# Фабрика значений

FactoryBot.define do
  sequence(:uniq)

  # Целые числа в заданном диапазоне или без него
  factory :integer do
    transient { range { nil } }

    skip_create
    initialize_with do
      if range.nil? || range.size.nil? || range.size.zero?
        generate(:uniq)
      else
        range.min + generate(:uniq) % range.size
      end
    end
  end

  # Строки
  factory :string do
    transient { length { nil } }

    skip_create
    initialize_with { format("%0#{length}d", generate(:uniq).to_s) }
  end

  # Строки шестнадцатеричных чисел
  factory :hex, class: String do
    transient { length { nil } }

    skip_create
    initialize_with { format("%0#{length}x", generate(:uniq)) }
  end

  # Даты без времени
  factory :date do
    transient do
      year  { nil }
      month { nil }
      day   { nil }
    end

    skip_create
    initialize_with do
      y = year  || create(:integer, range: 1980..2000).to_s
      m = month || create(:integer, range: 1..12).to_s
      d = day   || create(:integer, range: 1..28).to_s
      Date.strptime("#{y}.#{m}.#{d}", '%Y.%m.%d')
    end
  end

  # Время без даты
  factory :time do
    transient do
      seconds { nil }
      minutes { nil }
      hours   { nil }
    end

    skip_create
    initialize_with do
      s = seconds || create(:integer, range: 0..59).to_s
      m = minutes || create(:integer, range: 0..59).to_s
      h = hours   || create(:integer, range: 0..23).to_s
      Time.strptime("#{h}:#{m}:#{s}", '%H:%M:%S')
    end
  end

  # Булевы значения
  factory :boolean, class: Object do
    skip_create
    initialize_with { generate(:uniq).even? }
  end

  # Перечислимые значения
  factory :enum, class: Object do
    transient { values { nil } }

    skip_create
    initialize_with { values[create(:integer, range: 0...values.size)] }
  end

  # UUID
  factory :uuid, class: String do
    skip_create
    initialize_with do
      s = create(:hex, length: 32)
      "#{s[0..7]}-#{s[8..11]}-#{s[12..15]}-#{s[16..19]}-#{s[20..31]}"
    end
  end

  # СНИЛС
  factory :snils, class: String do
    skip_create
    initialize_with do
      s = create(:string, length: 11)
      "#{s[0..2]}-#{s[3..5]}-#{s[6..8]} #{s[9..10]}"
    end
  end
end
