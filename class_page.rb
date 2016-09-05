# question database logic

class Category
	
	def initialize(new_cat)
		$DATABASE.execute("INSERT INTO category(name) VALUES (?)", [new_cat])
	end

end


#Question class, taking the category question and answer as arguments

class Question
	attr_reader :category, :question, :answer, :points

	def initialize(category, question, answer, points)
		@category = category
		@question = question
		@answer = answer
		@points = points
	end
#add question to database using the local variables 
	def question_add
		$DATABASE.execute('INSERT INTO jeopardy (cat_id, question, answer,points) VALUES (?,?,?,?)', [category, question, answer, points])
	end

	def to_s
		puts "Category: #{category}" 
		puts "Question: #{question}"
		puts "Answer: #{answer}"
		puts "Points: #{points}"
	end

end


#Game logic 
class Player
	attr_accessor :points
	
	def initialize
		@points = 0
	end

end

class Game
	attr_reader :players, :winning

	def initialize 
		@players = []
		@winning = 0
	end

	def add_players(players_to_add)
		players_to_add.times do |x|
			@players << Player.new
		end
	end

#The winner is the player with the most points number is its spot in array + 1 
#(accounts for 0 index)

	def find_winner
		@counter = 0
		@players.each do |player|
			if player.points > @winning
				@winner = @counter + 1
			end
			@counter += 1
		end
		return @winner
	end

end

