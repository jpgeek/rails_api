# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    unless user
      raise Pundit::NotAuthorizedError,
        I18n.t("pundit.not_authenticated")
    end
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      unless user
        raise Pundit::NotAuthorizedError, I18n.t("pundit.not_authenticated")
      end
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private
      attr_reader :user, :scope
  end
end
