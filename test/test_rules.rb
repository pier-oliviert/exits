gem 'minitest'
require 'minitest/autorun'
require 'exits/rules'

class SomeController; end;
class User; end;

describe Exits::Rules do
  def setup
    @rules = Exits::Rules.new
  end

  describe Exits::Rules::User do
    def setup
      @rule = Exits::Rules::Model.new
    end

    it 'should not authorize if no rules have been set' do
      assert !@rule.authorized?(:show), "Shouldn't authorize :show"
    end

    it 'should be able to allow an action' do
      @rule.allow(:show)
      assert @rule.authorized?(:show), "Couldn't authorize :show"
    end

    it 'should make sure actions are unique' do
      @rule.allow(:show, :show)
      assert @rule.instance_variable_get("@actions").size == 1, "Should only be 1 instance of :show"
    end

    it 'should make a union of every call to Exits::Rules::User#allow' do
      @rule.allow(:show)
      @rule.allow(:show, :edit)
      actions = @rule.instance_variable_get("@actions")

      assert_equal [:show, :edit], actions, "Should only be 2 actions registered"
    end

    it 'should raise an error if :all is set with other actions' do
      assert_raises Exits::Rules::ConfusingRulesError do
        @rule.allow(:show)
        @rule.allow(:all)
      end
    end

    it 'should authorize any action if :all is set' do
      @rule.allow(:all)
      assert @rule.authorized?(:show), "Should authorize :show when :all is set"
    end
  end

  describe Exits::Rules::Controller do
    def setup
      @rule = Exits::Rules::Controller.new
    end

    it 'should not authorize if no rules have been set' do
      assert !@rule.authorized?(User, :show), "Shouldn't authorize User if there's no rule"
    end

    it 'should be able to add a rule & authorize' do
      @rule[User] = :show, :edit
      assert @rule.authorized?(User, :show), "Should authorize :show for User"
    end

  end

  it 'should be able to add rules' do
    @rules.add SomeController, User, [:show]
    controllers = @rules.instance_variable_get("@controllers")
    assert controllers.has_key?(SomeController), "No rules for #{SomeController.name}"
    assert !controllers[SomeController][User].nil?, "Couldn't add a rule for #{User.name}"
  end

  it 'should authorize a user matching the rule' do
    @rules.add SomeController, User, [:show]
    assert @rules.authorized?(SomeController, User, :show), "Couldn't authorize User in SomeController for :show"
  end

  it 'should prohibit a user accessing an undefined action' do
    @rules.add SomeController, User, [:show]
    assert !@rules.authorized?(SomeController, User, :edit), "Shouldn't authorize User in SomeController for :edit"
  end
end

