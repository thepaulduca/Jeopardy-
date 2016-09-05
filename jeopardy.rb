require 'sqlite3'
require_relative 'class_page'

$DATABASE = SQLite3::Database.new("jeopardy.db")

#create a table if it is not already in exsistence
create_main_table = <<-SQL
 CREATE TABLE IF NOT EXISTS jeopardy(
	id INTEGER PRIMARY KEY,
	cat_id INT,
	question VARCHAR(255),
	answer VARCHAR(255),
	points INT,
	FOREIGN KEY (cat_id) REFERENCES category(id)
	)
SQL

#create a category table
create_cat_table = <<-SQL
 CREATE TABLE IF NOT EXISTS category(
  id INTEGER PRIMARY KEY,
  name VARCHAR(255)
  )
SQL

$DATABASE.execute(create_main_table)
$DATABASE.execute(create_cat_table)



#User has ability to choose if they want to play a game or alter the game by adding new questions

puts "WELCOME TO Jeopardy!"
play = false
question_add = false
until play || question_add
puts "Would you like to play or add questions?"
puts "Type 1 to play and 2 to add questions"
primary_action = gets.chomp.to_i
	if primary_action == 1
		play = true
		game = Game.new
		puts "How many players would you like to create"
		num_of_players = gets.chomp.to_i
		game.add_players(num_of_players)
	elsif primary_action == 2
		question_add = true
	else
		puts "I didn't understandm please try again!"
	end 
end

# Get arguments to put into the question class and add the question to the database

if question_add
adding = true
until !adding
	puts "Would you like to create a category or add your question to an exsisting one!"
	puts "Type add or new!"
	add_or_new_cat = gets.chomp

	if add_or_new_cat == "new"
		puts "Please type the category now"
		new_cat_name = gets.chomp
		new_cat = Category.new(new_cat_name)
		cat_choice = $DATABASE.execute("SELECT id FROM category WHERE name = '#{new_cat_name}'")
		cat_choice = cat_choice[0][0]
	end

	if add_or_new_cat == "add"
		puts "What category would you like to make your question?"
		puts "Type the number associated with the category"
		puts $DATABASE.execute('SELECT * FROM category')
		cat_choice = gets.chomp.to_i
	end

	puts "Please type the question"
	question_choice = gets.chomp
	puts "What is the answer?"
	answer_to_ques = gets.chomp
	puts "How much is it worth? Use digits"
	points_for_question = gets.chomp.to_i
	new_question = Question.new(cat_choice,question_choice,answer_to_ques,points_for_question)
	new_question.question_add
	puts "Here is the question you added"
	puts new_question
	puts "Would you like to add another question? (y/n)"
	to_add = gets.chomp
	if to_add == "n"
		adding = false
	end
end 
end 

#Give the Option to play after adding questions
if !play
	puts "Would you like to play now? (y/n)"
	play_option = gets.chomp
end

#Set play to true
if play_option == 'y'
	puts"how many players do you want to play?"
	players_to_create = gets.chomp.to_i
	game = Game.new
	game.add_players(players_to_create)
	play = true
end




if play
game.players.each do |player| 
	puts "Please select a category!"
	p $DATABASE.execute('SELECT * FROM category')
	play_category = gets.chomp.to_i
	
	puts "Select the question based on points!"
	puts "------------"
	puts $DATABASE.execute("SELECT points FROM jeopardy WHERE cat_id = '#{play_category}'")
	puts "------------"
	point_selection = gets.chomp.to_i
	puts "------------"
	
	puts $DATABASE.execute("SELECT question FROM jeopardy WHERE points = #{point_selection}")
	points_at_steak = $DATABASE.execute("SELECT points FROM jeopardy WHERE points = #{point_selection}")
	puts "------------"
	first_answer = gets.chomp
	correct_answer = $DATABASE.execute("SELECT answer FROM jeopardy WHERE points = #{point_selection}")

	puts "------------"
	if first_answer == correct_answer[0][0]
		puts "Thats correct for #{points_at_steak[0][0]}"
		player.points += points_at_steak[0][0]
	else
		puts "I'm sorry the correct answer is :"
		puts $DATABASE.execute("SELECT answer FROM jeopardy WHERE points = #{point_selection}")
		player.points = player.points - points_at_steak[0][0]
	end

	puts "------------"
	puts "Points:"
	puts player.points
	puts "Next player!"
	puts "------------"

end
	winner = game.find_winner
	puts "The winner is.. ( Drum roll)"
	puts "Player #{winner}"

end


