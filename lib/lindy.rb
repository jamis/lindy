require 'lindy/parser'
require 'lindy/interpreter'

module Lindy
  def self.run(rules, order:nil)
    parser = Parser.new(rules)
    Interpreter.new.run(parser, order)
  end
end
