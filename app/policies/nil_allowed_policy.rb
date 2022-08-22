# frozen_string_literal: true

class NilAllowedPolicy < ApplicationPolicy
  # Override the superclass initializer to allow a nil user for this class only.
  def initialize(user, record)
    @user = user
    @record = record
  end

  def disallow_nil_user
    return unless @user.nil?
    raise Pundit::NotAuthorizedError,
      I18n.t("pundit.not_authenticated")
  end

  class Scope < Scope
    def resolve
      raise Pundit::NotDefinedError, "Cannot scope NilClass"
    end
  end
end
