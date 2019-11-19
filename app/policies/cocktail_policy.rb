class CocktailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(published: true)
    end
  end

  def update? ; user_is_owner? ; end
  def publish? ; update? ; end
  def destroy? ; user_is_owner? ; end

end
