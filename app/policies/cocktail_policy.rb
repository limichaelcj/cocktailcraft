class CocktailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update? ; user_is_owner? ; end
  def destroy? ; user_is_owner? ; end

  def user_is_owner?
    @user == @record.user
  end

end
