module TurtleGraphics
  class Turtle
    ORIENTATIONS = [:left, :up, :right, :down]

    def initialize(rows, cols)
      @rows = rows
      @cols = cols
      @matrix = Array.new(rows) { Array.new(cols, 0) }
      @position = { row: 0, col: 0 }
      @orientation = :right
      @default_spawn = true
    end

    def draw(&block)
      instance_eval(&block)
      @matrix[0][0] += @default_spawn == true ? 1 : 0
      @matrix.clone
    end

    def move
      advance_position
      normalise_position
      @matrix[@position[:row]][@position[:col]] += 1
    end

    def turn_right
      next_orientation_index = (ORIENTATIONS.index(@orientation) + 1)
      @orientation = ORIENTATIONS[next_orientation_index % ORIENTATIONS.count]
    end

    def turn_left
      next_orientation_index = (ORIENTATIONS.index(@orientation) - 1)
      @orientation = ORIENTATIONS[next_orientation_index % ORIENTATIONS.count]
    end

    def spawn_at(row, col)
      @default_spawn = false
      @position = { row: row, col: col }
      @matrix[@position[:row]][@position[:col]] += 1
    end

    def look(orientation)
      @orientation = orientation
    end

    private

    def advance_position
      case @orientation
      when :up
        @position[:row] -= 1
      when :down
        @position[:row] += 1
      when :left
        @position[:col] -= 1
      when :right
        @position[:col] += 1
      end
    end

    def normalise_position
      @position[:row] %= @rows
      @position[:col] %= @cols
    end
  end

  module Canvas
    class ASCII

    end

    class HTML

    end
  end
end
