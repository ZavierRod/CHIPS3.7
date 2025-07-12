class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  attr_accessor :word, :guesses, :wrong_guesses


  def check_win_or_lose
    if word_with_guesses == @word
      return :win
    end
    if @wrong_guesses.length > 6
      return :lose
    else
      return :play
    end
  end

  def word_with_guesses
    # create copy of word but replace with dashes
    answer = '-' * word.length
    # Go through that, each time 
    @word.chars.each_with_index do |char, i|
      @guesses.chars.each do |guess|
        if guess == char
          answer[i] = char
        end
      end
    end
    return answer
  end

 def invalid?(user_guess)
    if user_guess.nil? 
      raise ArgumentError, "Guess can't be nil"
    end
    if user_guess == '' 
      raise ArgumentError, "Guess can't be nothing"
    end
    if !user_guess.match?(/\A\p{Alpha}\z/) 
      raise ArgumentError, "Guess has to be an alphabetic letter"
    end
  end


  def guess(user_guess)
    # Raise error if not a valid character
    invalid?(user_guess)

    already_guessed = false
    user_guess = user_guess.downcase
    user_guess.chars.each do |char|
      if !@guesses.include?(char) && !@wrong_guesses.include?(char)# If it hasn't been guessed before
        if @word.include?(char) # If the character is in the word
          @guesses << char # Add it to the correct guesses
        else # If the character is not in the word
          if !char.match?(/\A\p{Alpha}\z/) # Raise error if not a valid character
            raise ArgumentError, "Guess has to be an alphabetic letter"
          else
            @wrong_guesses << char# Add it to the wrong guesses
          end
        end
      else # If it has been seen before
        already_guessed = true 
      end
    end
    return !already_guessed # Return true if it hasn't been seen, false if it has been seen
  end
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
