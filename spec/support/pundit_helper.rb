module Support
  module PunditHelper
    def controller_methods
      %i[index? show? create? new? update? edit? destroy?]
    end

    def model_from_policy(policy)
      policy.name.sub(/Policy\z/, '').constantize
    end

    #def independent_controller_methods
    #  %i[index? show? create? update? destroy?]
    #end
  end
end

RSpec::Matchers.define :raise_not_authorized do |action, *args|
  match do |policy|
    args ||= []
    raised = false
    begin
      policy.public_send("#{action}?", *args)
    rescue Pundit::NotAuthorizedError
      raised = true
    end
    raised
  end

  failure_message do |policy|
    "#{policy.class} does not raise NotAuthorizedError on #{action} for " +
      policy.public_send(Pundit::Matchers.configuration.user_alias)
      .inspect + '.'
  end

  failure_message_when_negated do |policy|
    "#{policy.class} raises NotAuthorizedError on #{action} for " +
      policy.public_send(Pundit::Matchers.configuration.user_alias)
      .inspect + '.'
  end
end
