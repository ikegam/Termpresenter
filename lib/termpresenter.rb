#!/usr/bin/ruby

require 'aastring.rb'
require 'curses'

class Tmptr

  def initialize(content)
    @current_index = 0
    @content = content
    Curses.init_screen
    Curses.noecho
    @term = Curses.stdscr
    setup
  end

  def setup(h=?|, w=?-, s=?*)
    @term.box(h, w, s)
    @term.refresh
  end

  def view(index)
    @current_index = index
    @term.clear
    setup
    i = 2
    @content.get_content(index).to_aa.split("\n").each{|line|
      @term.setpos(i, 2)
      @term.addstr(line)
      i = i + 1
    }
    @term.setpos(0, 0)
    @term.refresh
  end

  def next()
    view(@current_index + 1)
  end

  def prev()
    view(@current_index - 1)
  end

  def start(&block)
    view(0)
    while true
      block.call(self, @term.getch)
    end
  end

end

if $0 == __FILE__
  require 'termpresenter_file_loader.rb'

  content = Tmptr_content.new_bydir("../presen/")
  tmptr = Tmptr.new(content)

  tmptr.start{|term, key|
    case key
    when 110
      term.next()
    when 112
      term.prev()
    else
      p key if $DEBUG
    end
  }
end

