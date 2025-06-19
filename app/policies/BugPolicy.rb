class BugPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def index?
    user.manager? || user.qa? || record.project.users.include?(user)
  end

  def show?
    record.project.users.include?(user)
  end

  def create?
    !user.developer?
  end

  def update?
    !user.qa?
    # user.developer? || user.manager?
  end

  def destroy?
    user.manager?
  end

  def assign_to_self?
    user.developer? 
  end

  def mark_resolved?
    user.developer? && record.developer == user
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
        def resolve
      if user.manager?
        scope.all
      elsif user.qa?
        scope.all
      elsif user.developer?
        scope.joins(project: :users).where(users: { id: user.id })
      else
        scope.none
      end
    end
  end
end
