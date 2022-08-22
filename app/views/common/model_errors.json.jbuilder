# frozen_string_literal: true

json.errors instance.errors do |err|
  json.attribute err.attribute
  json.message err.message
  json.full_message err.full_message
end
