require 'mkmf'

class RspecGods
  @@god = nil

  GODS = [
    'Agnes',
    'Kathy',
    'Princess',
    'Vicki',
    'Victoria',
    'Bruce',
    'Fred',
    'Junior',
    'Ralph',
    'Albert',
    'Bad News',
    'Bahh',
    'Bells',
    'Boing',
    'Bubbles',
    'Cellos',
    'Deranged',
    'Good News',
    'Hysterical',
    'Pipe Organ',
    'Trinoids',
    'Whisper',
    'Zarvox'
  ]

  class << self
    def to_say(words = '')
      print "\n\n"
      @@god || summon(GODS.sample)
      fork { exec "say -v #{@@god} \"#{words}\"" } if find_executable 'say'
      puts "Rspec god '#{@@god.capitalize}' says \"#{words}\"."
    end
    alias_method :say, :to_say

    def summon(god = nil)
      @@god = god
      throw 'This God of Rspec is unknown' unless @@god.in? GODS
      self
    end
  end
end
