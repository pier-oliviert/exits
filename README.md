# Exits [![Code Climate](https://codeclimate.com/github/pothibo/exits.png)](https://codeclimate.com/github/pothibo/exits) [![Build Status](https://travis-ci.org/pothibo/exits.png)](https://travis-ci.org/pothibo/exits)
When you want to restrict access to your Rails application.

## Description
You want to restrict access to your application so Administrator & User can have different access level. Exits provides two level of authorization that works in conjunction so you can fine tuned access to your need. All the authorization logic is set in the *controller* to make it easy for you to figure out who has access to what.

Designed with an emphasis on readability, it also is designed to work with your authentication setup(Warden, Devise).


## How to use

Let's assume you have Admin & User and want to let admin have access to everything and restrict User to edit their own stuff.

```ruby
# controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :restrict_routes!
end
```

For Exits to work, you need to add `before_action :restrict_routes!` to your ApplicationController.
```ruby
# controllers/posts_controller.rb
class PostsController < ActionController::Base
  allow Admin, :all
  allow User, :resources, :follow
  
  def admin
  end

  def follow
    #Follow another user
  end
	
  def edit
    @post = Post.find params[:id].to_i
    allow! User do
      current_user.eql? @post.user
    end
  end
end
```

Exits takes a very strict approach to handling access. If you don't allow access to an action for a given user class, _it won't be authorized to access such action._

This is by designed, it's a tradeoff between boilerplate code & readability. It's much easier to understand permissions if they are explicit in every controller and presented in the same manner throughout your application.

To give access to a controller, you have to use `allow` the class as shown above in PostsController[line 2-3].

If you need to be more specific about a permission, you can be more precise inside the controller method using `allow!`. This method takes a block that needs to return _true_ or _false_.

If it returns false, Exits will raise an exception and redirect you to :root (You can customize this behavior). 

*Remember:* You have to set permission inside your controller's class. If a user class does not have permission to access the controller, it will never reach the controller's method! e.g PostsController#edit

### Aliases

There is currently two aliases: ```:all``` and ```:resources```. They are shown above inside the PostsController.

If you want to allow a certain model on the whole resource
```ruby allow User, :resources```

This is the same as doing
```ruby allow User, :new, :show, :edit, :index, :create, :update, :destroy```

If you want to let a user access _every_ action available in a controller, you may use
```ruby allow User, :all```

### Unauthorized
When a user is unauthorized the default behavior is to set a flash message and redirect to :root.

You can override this behavior.

```ruby
# controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :restrict_routes!
  
  def unauthorized	(exception)
    # Handle unauthorized user here
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exits'
```

And then execute:

```bash
$ bundle
```

## Test
Exits comes with a test suite.

```bash
$ rake test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
