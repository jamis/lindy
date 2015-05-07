module Lindy
  class Point < Struct.new(:x, :y)
    def +(point)
      Point.new(x + point.x, y + point.y)
    end

    def -(point)
      Point.new(x - point.x, y - point.y)
    end

    def *(m)
      Point.new(m * x, m * y)
    end

    def magnitude
      @magnitude ||= Math.sqrt(x*x + y*y)
    end

    def normalize
      Point.new(x / magnitude, y / magnitude)
    end

    def rotate(theta)
      Point.new(
        x * Math.cos(theta) - y * Math.sin(theta),
        y * Math.cos(theta) + x * Math.sin(theta))
    end

    def to_s
      "(%.2f,%.2f)" % [x,y]
    end
  end
end
