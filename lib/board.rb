class Board
	def initialize player
		@player = player
		#@rows = Array.new(10) { Array.new(10) { '' } }
		@rows = [
			       [" "," "," "," "," "," "," ","s","s","s"],
			       [" "," "," "," "," "," "," "," "," "," "],
			       [" "," "," "," "," "," "," "," "," "," "],
			       [" "," ","s"," "," "," "," "," "," "," "],
			       [" "," ","s"," "," "," "," "," "," "," "],
			       [" "," ","s"," "," "," "," "," "," "," "],
			       [" "," "," "," "," "," "," "," "," "," "],
			       [" "," "," "," "," "," "," "," "," "," "],
			       ["s"," "," "," "," "," "," "," "," "," "],
			       ["s"," "," "," "," "," "," "," "," "," "]
			     ]
		@x_axis = { "A" => 0, "B" => 1, "C" => 2, "D" => 3,"E" => 4, "F" => 5,
							"G" => 6, "H" => 7, "I" => 8, "J" => 9
						}
	end

	def add_a_ship length

		x, y, direction = random_start
		while !is_water_clear?(length, [x,y], direction)
			x, y, direction = random_start
		end
		place_ship(length, [x,y], direction)
	end

	def populate

		add_a_ship 5
		add_a_ship 4
		add_a_ship 3
		add_a_ship 3
		add_a_ship 2
	end

	def clear
			@rows = @rows.map {|a| a.map {|cell| " "}}
	end

	def random_start
		@directions = [:north,:south,:east,:west]
		@values = [0,1,2,3,4,5,6,7,8,9]
		[@values.sample,@values.sample,@directions.sample]
	end	

	def check_coords coords_array
		x, y = coords_array
		@rows[y][x]
	end

	def set_value_at_coords value, coords_array
		x, y = coords_array
		@rows[y][x] = value
	end

	def register_shot at_coordinates
		converted_coordinates = convert_coords(at_coordinates)
		old_value = check_coords(converted_coordinates)
		set_value_at_coords("o", converted_coordinates) if old_value == " "
		set_value_at_coords("x", converted_coordinates) if old_value == "s"			
	end

	def convert_coords coords
		x = @x_axis[coords[0].upcase]
		y = coords.slice(1..-1).to_i - 1
		[x, y]
	end

	def opponents_view
		@rows.map {|a| a.map {|cell| cell == "s" ? " " : cell}}
	end

	def place_ship length, coords, direction
		x, y = coords
	
		case direction # this works... but its too fking! long.. refactor
		when :north 
			@rows[y][x]   = "s"
			@rows[y-1][x] = "s"
			@rows[y-2][x] = "s" if length > 2
			@rows[y-3][x] = "s" if length > 3
			@rows[y-4][x] = "s" if length > 4	
		when :south 
			@rows[y][x]   = "s"
			@rows[y+1][x] = "s"
			@rows[y+2][x] = "s" if length > 2
			@rows[y+3][x] = "s" if length > 3
			@rows[y+4][x] = "s" if length > 4	
		when :east
			@rows[y][x]   = "s"
			@rows[y][x+1] = "s"
			@rows[y][x+2] = "s" if length > 2
			@rows[y][x+3] = "s" if length > 3
			@rows[y][x+4] = "s" if length > 4	
		when :west
			@rows[y][x]   = "s"
			@rows[y][x-1] = "s"
			@rows[y][x-2] = "s" if length > 2
			@rows[y][x-3] = "s" if length > 3
			@rows[y][x-4] = "s" if length > 4	
		end
	end

	def owner
		@player.name
	end

	def rows
		@rows
	end

	def is_water_clear?(ship_length, at_coordinates, direction)
		x,y = at_coordinates
		ship = Array.new(ship_length) { " " }
		comparison_array = is_east_clear?(ship_length,x,y) if direction == :east
		comparison_array = is_west_clear?(ship_length,x,y) if direction == :west
		comparison_array = is_north_clear?(ship_length,x,y,ship) if direction == :north
		comparison_array = is_south_clear?(ship_length,x,y) if direction == :south
		ship == comparison_array
	end

	def is_east_clear? ship_length, x, y
		@rows[y].slice(x...(x + ship_length))
	end

	def is_west_clear? ship_length, x, y
		@rows[y].slice((x-ship_length+1)..x)
	end

	def is_south_clear? ship_length, x, y
		array = []
		ship_length.times { |i| @rows[y+i].nil? ? array << "nil" : array << @rows[y+i][x] }
		array
	end

	def is_north_clear? ship_length, x, y, ship
		ship.inject([]) do |array, co| 
				y -= 1
				@rows[y+1].nil? ? array << "nil" : array << @rows[y+1][x]
			end
	end

end