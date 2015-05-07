require 'chunky_png'
require 'lindy/point'

module Lindy
  class Canvas
    def initialize
      @lines = []
      @min_x = @max_x = @min_y = @max_y = 0
      @current = Point.new(0,0)
    end

    def move_to(point)
      @current = point
      _update_extents(point)
    end

    def line_to(point)
      @lines << [@current, point]
      _update_extents(point)
      @current = point
    end

    def _update_extents(point)
      @min_x = point.x if point.x < @min_x
      @max_x = point.x if point.x > @max_x
      @min_y = point.y if point.y < @min_y
      @max_y = point.y if point.y > @max_y
    end

    def to_png(scale=1)
      width = @max_x - @min_x
      height = @max_y - @min_y
      ofx = -@min_x
      ofy = -@min_y

      x_margin = width * 0.1
      y_margin = height * 0.1

      ofx += x_margin
      ofy += y_margin

      width = ((width + x_margin*2) * scale).to_i
      height = ((height + y_margin*2) * scale).to_i

      image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)

      @lines.each do |line|
        x1 = (ofx + line[0].x) * scale
        y1 = (ofy + line[0].y) * scale
        x2 = (ofx + line[1].x) * scale
        y2 = (ofy + line[1].y) * scale

        image.line(x1.round, y1.round, x2.round, y2.round, ChunkyPNG::Color::BLACK)
      end

      image
    end
  end
end
