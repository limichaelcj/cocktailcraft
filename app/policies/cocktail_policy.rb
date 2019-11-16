class CocktailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update? ; user_is_owner? ; end
  def destroy? ; user_is_owner? ; end

end
