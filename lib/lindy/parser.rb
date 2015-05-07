module Lindy
  class Parser
    attr_reader :start
    attr_reader :rules
    attr_reader :commands
    attr_reader :step
    attr_reader :angle

    DEFAULT_COMMANDS = {
      'F' => :move,
      '+' => :right,
      '-' => :left,
      '[' => :push,
      ']' => :pop
    }

    def initialize(definition)
      @start    = definition['start']
      @rules    = definition['rules']
      @commands = DEFAULT_COMMANDS.merge(definition['commands'] || {})
      @step     = definition['step'] || 10
      @order    = definition['order'] || 1

      if definition['angle']
        angle = definition['angle'] * Math::PI / 180.0
        @left_angle = -angle
        @right_angle = angle
      end

      if definition['left-angle']
        @left_angle = -definition['left-angle'] * Math::PI / 180.0
      end

      if definition['right-angle']
        @right_angle = definition['right-angle'] * Math::PI / 180.0
      end
    end

    def parse(order=nil, &block)
      _parse(@start, order || @order, &block)
    end

    def _parse(string, order, &block)
      string.each_char do |char|
        substitution = @rules[char]
        command = @commands[char]

        if substitution && order > 0
          _parse(substitution, order-1, &block)

        elsif command
          case command
            when :move
              yield [command, @step, order]
            when :push, :pop
              yield [command, nil, order]
            when :right
              yield [:turn, @right_angle, order]
            when :left
              yield [:turn, @left_angle, order]
            else
              raise ArgumentError, "unknown command: #{command.inspect}"
          end
        end
      end
      self
    end
  end
end
