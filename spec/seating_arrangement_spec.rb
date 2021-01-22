require_relative '../seating_arrangement'
require 'pry'

describe SeatingArrangement do
  describe 'method#initialize' do
    context 'check if the input arguments are valid or not' do
      describe 'method#validate_input' do
        context 'when the 2D array is not valid' do
          let(:count) { 59 }

          let(:matrix1) { [[3,2],2,[4],[3,4]] }
          let(:matrix2) { [[3,2],[2],[4,3,4],[3,4]] }
          let(:matrix3) { [[3,2],[2,0],[4,3],[3,4]] }

          let!(:message_1) { 'The given array is not in 2D format!' }
          let!(:message_2) { 'All the sub-arrays of the given 2D array are not of [x,y] format!' }
          let!(:message_3) { "The sub-arrays are in [x,y] format but 'x' and 'y' should be NON-ZERO values!" }

          it "returns a proper validation message when any element of the given 2D array is not an array" do
            obj = SeatingArrangement.new(matrix1, count)
            expect(obj.message).not_to be_nil
            expect(obj.message).to eql(message_1)
          end

          it "returns a proper validation message when any element of the given 2D array is not an array of [x,y] format" do
            obj = SeatingArrangement.new(matrix2, count)
            expect(obj.message).not_to be_nil
            expect(obj.message).to eql(message_2)
          end

          it "returns a proper validation message when any sub array element contain x or y values as zero" do
            obj = SeatingArrangement.new(matrix3, count)
            expect(obj.message).not_to be_nil
            expect(obj.message).to eql(message_3)
          end
        end

        context 'when the 2nd argument is not an integer' do
          let(:matrix) { [[3,2],[2,5],[4,8],[3,4]] }
          let(:count1) { "a" }
          let!(:message1) { 'The second argument should be a integer' }

          let(:count2) { 0 }
          let!(:message2) { 'The second argument should be a positive integer' }

          it "returns a proper validation message the 2nd argument is not an integer" do
            obj = SeatingArrangement.new(matrix, count1)
            # binding.pry
            expect(obj.message).not_to be_nil
            expect(obj.message).to eql(message1)
          end

          it "returns a proper validation message the 2nd argument should be positive integer" do
            obj = SeatingArrangement.new(matrix, count2)
            # binding.pry
            expect(obj.message).not_to be_nil
            expect(obj.message).to eql(message2)
          end
        end

        context 'when both the inputs are correct' do

          let(:matrix) { [[3,2],[2,5],[4,8],[3,4]] }
          let(:count) { 59 }

          it "returns no validation message" do
            obj = SeatingArrangement.new(matrix, count)
            expect(obj.message).to be_nil
          end
        end
      end
    end

    context 'check if the instance is getting initialized with the required attributes' do
      let(:matrix) { [[3,2],[2,5],[4,8],[3,4]] }
      let(:count) { 59 }
      let(:max_seats) { (3*2) + (2*5) + (4*8) + (3*4) }

      it "sets the maximum seats available" do
        obj = SeatingArrangement.new(matrix, count)
        expect(obj.max_seats).not_to be_nil
        expect(obj.max_seats).to equal(max_seats)
      end

      it "sets the passengers count" do
        obj = SeatingArrangement.new(matrix, count)
        expect(obj.passengers_count).not_to be_nil
        expect(obj.passengers_count).to equal(59)
      end
    end
  end

  describe 'method#arragement' do
    context 'allocation and arrangement of seats for the people waiting in the queue' do
      describe 'method#allocate_aisle_seats' do
        context 'allocating asile seats first' do
          let(:matrix) { [[3,2],[4,3],[2,3],[3,4]] }
          let(:count) { 30 }
          let(:aisle_seats) { (1..18).to_a }

          it "allocates the aisle seats in the correct order" do
            obj = SeatingArrangement.new(matrix, count)
            seating = obj.arrangement
            temp = seating.map { |x| x.map { |y| y.values_at(0,-1) unless y.nil? } }
            aisle_seats_array = temp.map { |x| x.flatten }.map { |x| x[1..x.size - 2] }.flatten.compact.map(&:to_i)
            expect(aisle_seats_array).to eql(aisle_seats)
          end
        end
      end

      describe 'method#allocate_window_seats' do
        context 'allocating windows seats next' do
          let(:matrix) { [[3,2],[4,3],[2,3],[3,4]] }
          let(:count) { 30 }
          let(:windows_seats) { (19..24).to_a }

          it "allocates the windows seats in the correct order" do
            obj = SeatingArrangement.new(matrix, count)
            seating = obj.arrangement
            temp = seating.map { |x| x.map { |y| y.values_at(0,-1) unless y.nil? } }
            window_seats_array = temp.map { |x| x.flatten }.map { |x| x.values_at(0,-1) }.flatten.compact.map(&:to_i)
            expect(window_seats_array).to eql(windows_seats)
          end
        end
      end

      describe 'method#allocate_center_seats' do
        context 'allocating center seats last' do
          let(:matrix) { [[3,2],[4,3],[2,3],[3,4]] }
          let(:count) { 30 }
          let(:center_seats) { (25..30).to_a }

          it "allocates the center seats in the correct order" do
            obj = SeatingArrangement.new(matrix, count)
            seating = obj.arrangement
            temp = seating.map { |x| x.map { |y| y[1..y.size-2] unless y.nil? } }
            center_seats_array = temp.flatten.reject { |x| x == 'XX' }.compact.map(&:to_i)
            expect(center_seats_array).to eql(center_seats)
          end
        end
      end
    end
  end
end
