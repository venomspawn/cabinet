# frozen_string_literal: true

# Настройка неточного поиска

# Загрузка движка неточного поиска
Cab.need 'lookup/fuzzy'

# Установка параметров неточного поиска
Cab::Lookup::Fuzzy.configure do |settings|
  # Коэффициенты для меры совпадения. Чем меньше коэффициент, тем более
  # неточным позволяется совпадение.
  settings.set :first_name,  0.5
  settings.set :last_name,   1.0
  settings.set :middle_name, 0.1
  settings.set :birth_place, 0.2
end
