require 'pry'

class SeatingArrangement

  attr_accessor :excess_booking, :max_seats, :passengers_count, :message

  def initialize(matrix, count)
    @message = validate_input(matrix, count)
    if @message.nil?
      @max_seats = @input_seats.inject(0) { |sum, x| sum += x[0] * x[1] }
      @excess_booking = true if @max_seats < @passengers_count
      @max_columns = @input_seats.map(&:last).max
      @passengers_allocated = 0
    end
  end

  def arrangement
    prepare_seats
    allocate_aisle_seats
    allocate_window_seats
    allocate_center_seats
  end

  def validate_input(matrix, count)
    @input_seats = matrix
    @passengers_count = count
    return "The given array is not in 2D format!" unless @input_seats.all? { |x| x.is_a?(Array) }
    return "All the sub-arrays of the given 2D array are not of [x,y] format!" unless @input_seats.all? { |x| x.size == 2 }
    return "The sub-arrays are in [x,y] format but 'x' and 'y' should be NON-ZERO values!" if @input_seats.any? { |x| x.any?(0) }
    return "The second argument should be a integer" unless @passengers_count.is_a?(Integer)
    return "The second argument should be a positive integer" unless @passengers_count > 0
  end
  

  def self.seating_arrangement(matrix, passanger_count)
    seating = SeatingArrangement.new(matrix, passanger_count)
    if seating.message.nil?
      if (seating.excess_booking)
        puts "Sorry! We don't have enough seats to occupy #{seating.passengers_count} passengers.\
        Only #{seating.max_seats} seats are available!"
      else
        return seating.arrangement
      end
    else
      puts seating.message
    end
  end

  private

  def prepare_seats
    @available_seats = @input_seats.each_with_object([]).with_index do |(arr, seats), index|
      seats << (1..arr[1]).map { |x| Array.new(arr[0]) { 'N' } }
    end
    @sorted_seats = (1..@max_columns).each_with_object([]).with_index do |(x, arr), index|
      arr << @available_seats.map { |x| x[index] }
    end
  end

  def allocate_aisle_seats
    @aisle_seats = @sorted_seats.each_with_object([]) do |elem_array, res_array|
      res_array << if elem_array.nil?
        nil
      else
        elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
          update_arr << if basic_elem_array.nil?
            nil
          else
            if index == 0
              @passengers_allocated += 1
              basic_elem_array[-1] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
            elsif index == elem_array.size - 1
              unless basic_elem_array.size == 1
                @passengers_allocated += 1
                basic_elem_array[0] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
              end
            else
              @passengers_allocated += 1
              basic_elem_array[0] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
              unless basic_elem_array.size == 1
                @passengers_allocated += 1
                basic_elem_array[-1] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
              end
            end
            basic_elem_array
          end
        end
      end
    end
  end

  def allocate_window_seats
    @window_seats = @aisle_seats.each_with_object([]) do |elem_array, res_array|
      res_array << if elem_array.nil?
        nil
      else
        elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
          update_arr << if basic_elem_array.nil?
            nil
          else
            if index == 0
              @passengers_allocated += 1
              basic_elem_array[0] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
            elsif index == elem_array.size - 1
              @passengers_allocated += 1
              basic_elem_array[-1] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
            end
            basic_elem_array
          end
        end
      end
    end
  end

  def allocate_center_seats
    @center_seats = @window_seats.each_with_object([]) do |elem_array, res_array|
      res_array << if elem_array.nil?
        nil
      else
        elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
          update_arr << if basic_elem_array.nil?
            nil
          else
            if basic_elem_array.size > 2
              (1..basic_elem_array.size - 2).each do |x|
                @passengers_allocated += 1
                basic_elem_array[x] = @passengers_allocated <= @passengers_count ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
              end
            end
            basic_elem_array
          end
        end
      end
    end
  end

end
