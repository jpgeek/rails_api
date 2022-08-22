class ErrorPayload
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier
  end

  def as_json(*)
    { error:
      {
        status: status_code,
        code: identifier,
        title: translated_payload[:title],
        detail: translated_payload[:detail],
      }
    }
  end

  def status_code
    Rack::Utils.status_code(translated_payload[:status])
  end

  def translated_payload
    I18n.translate("errors.#{identifier}")
  end
end
