class DosePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create? ; user_is_cocktail_owner? ; end
  def destroy? ; user_is_cocktail_owner? ; end

end
