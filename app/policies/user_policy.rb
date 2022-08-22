class UserPolicy < NilAllowedPolicy
  def index?
    disallow_nil_user
    user.admin?
  end

  def show?
    disallow_nil_user
    user.admin? || self?
  end

  def create?
    true
  end

  def update?
    disallow_nil_user
    show?
  end

  def destroy?
    disallow_nil_user
    false
  end

  def self?
    disallow_nil_user
    user.id == record.id || user.equal?(record)
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      return scope.none if user.nil?
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
