require "exits/version"
require 'exits/rules'

module Exits

end

if defined? Rails
  require 'exits/railtie'
end
