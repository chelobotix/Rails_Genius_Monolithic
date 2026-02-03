class PostPolicy < ApplicationPolicy
  def index?
    post.published?
  end

  def show?
    if !post.published? && post.user == user || user.is_admin
      true
    elsif post.published?
      true
    else
      false
    end
  end

  def create?
    user.is_admin
  end
end
