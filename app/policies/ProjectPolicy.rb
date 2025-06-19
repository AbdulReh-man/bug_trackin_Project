class ProjectPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def index?
    true
  end

  def show?
    user.manager? || user.qa? 
  end

  def create?
    user.manager?
  end

  def update?
    user.manager? && creator?(record)
  end

  def destroy?
    user.manager? && creator?(record)
  end

  def add_user?
    user.manager? 
  end

  private
  def creator?(project)
    UserProject.exists?(user: user, project: project)
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
     def resolve
      if user.manager?
        scope.all
        # scope.joins(:user_projects).where(user_projects: { user_id: user.id })
      elsif user.qa?
        scope.all
      elsif user.developer?
       scope.joins(:user_projects).where(user_projects: { user_id: user.id })
      else
        scope.none
      end
    end
  end
end
