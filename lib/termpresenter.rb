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

  def reflesh()
    view(@current_index)
  end

  def view(index)
    index = (index % @content.pages)
    @current_index = index
    @term.clear
    setup
    box_addstr(@content.get_content(index).to_aa, 2, 2)
    @term.setpos(0, 0)
    @term.refresh
  end

  def box_addstr(str, x, y)
    i = y
    str.split("\n").each{|line|
      @term.setpos(i, x)
      @term.addstr(line)
      i = i + 1
    }
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
      block.call(@term, @term.getch)
    end
  end

  def execute_command()
    sub = Tmptr_command_window.new(@term, 3, 30, 4, 4)
    Curses.echo
    @term.setpos(5, 5)
    command = @term.getstr
    Curses.noecho
    sub.close
    reflesh
    sub = Tmptr_result_window.new(@term, 30, 30, 4, 4)
    @term.setpos(5, 5)
    ret = %x{#{command.chomp} | cut -b '1-28'} + "\n enter key"
    box_addstr(ret, 5, 5)
    @term.getstr
    sub.close
    reflesh
  end

end

class Tmptr_sub_window_core

  def initialize(parent, height, width, y, x)
    @parent = parent
    @subwindow = parent.subwin(height, width, y, x)
    setup
  end

  def setup(h=?|, w=?-, s=?*)
    @subwindow.clear
    @subwindow.box(h, w, s)
    @subwindow.refresh
  end

  def close()
    @subwindow.close
  end

end

class Tmptr_command_window < Tmptr_sub_window_core
end

class Tmptr_result_window < Tmptr_sub_window_core
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

