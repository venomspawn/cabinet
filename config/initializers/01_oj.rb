# frozen_string_literal: true

# Настройка библиотеки Oj

require 'oj'

Oj.default_options = { mode: :json, symbol_keys: true }
