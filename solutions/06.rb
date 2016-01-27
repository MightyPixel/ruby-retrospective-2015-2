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

    def draw(canvas = nil, &block)
      instance_eval(&block)
      @matrix[0][0] += @default_spawn == true ? 1 : 0
      canvas ? canvas.build(@matrix) : @matrix
    end

    def move
      advance_position
      @position[:row] %= @rows
      @position[:col] %= @cols
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
      when :up then @position[:row] -= 1
      when :down then @position[:row] += 1
      when :left then @position[:col] -= 1
      when :right then @position[:col] += 1
      end
    end
  end

class Canvas
    def self.max_steps(canvas)
      canvas.map { |row| row.max }.max
    end

    class ASCII
      def initialize(characters)
        @characters = characters
      end

      def build(canvas)
        max_steps = Canvas.max_steps(canvas)
        ascii_rows = canvas.map do |row|
          row_of_characters = row.map do |cell|
            @characters[((@characters.size - 1) * cell.to_f / max_steps).ceil]
          end
          row_of_characters.join
        end
        ascii_rows.join("\n")
      end
    end

    class HTML
      def initialize(cell_size)
        @html_string = <<-CODE.gsub(/^\s{8}/, '')
        <!DOCTYPE html>
        <html>
        <head>
          <title>Turtle graphics</title>

          <style>
            table {
              border-spacing: 0;
            }

            tr {
              padding: 0;
            }

            td {
              width: #{cell_size}px;
              height: #{cell_size}px;

              background-color: black;
              padding: 0;
            }
          </style>
        </head>
        <body>
          <table>
          %s
          </table>
        </body>
        </html>
        CODE
      end

      def build(canvas)
        max_steps = Canvas.max_steps(canvas)
        table_rows = canvas.map do |row|
          table_data = row.map do |cell|
            '<td style="opacity: ' +
              format('%.2f', cell.to_f / max_steps) +
                '"></td>'
          end
          '<tr>' + table_data.join + '</tr>'
        end
        @html_string % table_rows.join
      end
    end
  end
end
