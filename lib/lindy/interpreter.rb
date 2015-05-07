require 'lindy/canvas'
require 'lindy/point'

module Lindy
  class Interpreter
    def run(parser, order)
      stack = []
      canvas = Canvas.new
      position = Point.new(0, 0)
      vector = Point.new(0, -1)

      canvas.move_to(position)

      parser.parse(order) do |command, arg, d|
        case command
          when :move
            new_pos = position + vector * arg
            canvas.line_to(new_pos)
            position = new_pos

          when :turn
            vector = vector.rotate(arg)

          when :push
            stack.push [position, vector]

          when :pop
            position, vector = stack.pop
            canvas.move_to(position)

          else
            raise "unknown command: #{command.inspect}"
        end
      end

      canvas
    end
  end
end
