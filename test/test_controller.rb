gem 'minitest'
require 'minitest/autorun'
require 'exits/rules'
require 'exits/action_controller/helpers'

class User
  attr_accessor :id
end

class Admin < User; end;

class SomeController
  include ActiveSupport::Rescuable
  include Exits::ActionController::Helpers
  attr_accessor :action_name, :current_user

  allow Admin, :all
  allow User, :show, :index
  
  def index
    @user = User.new
    @user.id = 1
    allow! User do
      current_user.id == @user.id
    end
    return true
  end

end


describe Exits::ActionController::Helpers do
  def setup
    @controller = SomeController.new
  end

  it 'should not authorize a user at the controller level' do
    @controller.action_name = :edit
    @controller.current_user = User.new

    assert_raises Exits::Rules::Unauthorized do
      @controller.send(:restrict_routes!)
    end
  end

  it 'should not authorize a user at the action level' do
    @controller.action_name = :edit
    @controller.current_user = User.new

    assert_raises Exits::Rules::Unauthorized do
      @controller.index
    end
  end

  it 'should authorize a user' do
    @controller.action_name = :show
    assert @controller.class.rules.authorized? @controller.class, User, @controller.action_name
  end

  it "should not authorize a user if he is not allowed within the action" do
    @user = User.new
    @user.id = 2
    @controller.action_name = :index
    @controller.current_user = @user
    assert_raises Exits::Rules::Unauthorized do
      @controller.index
    end
  end

  it "should allow a user only if he's cleared the 2 levels" do
    @user = User.new
    @user.id = 1
    @controller.action_name = :index
    @controller.current_user = @user
    assert @controller.class.rules.authorized?(@controller.class, @user.class, @controller.action_name), "Should be allowed on the controller level"
    assert @controller.index, "Should be allowed on the action level"
  end

end

