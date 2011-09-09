module Bresenham
  # This is the standard Bresenham line algorithm with the pixel draw implemented
  # as a yield. My intent in including it was to allow for drawing at arbitrary angles
  # (which would require a different method of handling angled movement as well)
  # and to avoid reinventing a 50-year-old wheel.

  def self.draw_line(p1, p2)
    x1, y1 = p1.first, p1.last
    x2, y2 = p2.first, p2.last
 
    steep = (y2 - y1).abs > (x2 - x1).abs
 
    if steep
      x1, y1 = y1, x1
      x2, y2 = y2, x2
    end
 
    if x1 > x2
      x1, x2 = x2, x1
      y1, y2 = y2, y1
    end
 
    delta_x = x2 - x1
    delta_y = (y2 - y1).abs
    error = delta_x / 2
    y_step = y1 < y2 ? 1 : -1
 
    y = y1
    x1.upto(x2) do |x|
      pixel = steep ? [y,x] : [x,y]
      yield pixel
      error -= delta_y
      if error < 0
        y += y_step
        error += delta_x
      end
    end
  end
end
