#!/usr/bin/ruby

require 'aastring.rb'
require 'curses'

class Tmptr_slide
  require 'tempfile'
  attr_writer :font_size

  def initialize(tmptr, raw_page)
    @tmptr = tmptr
    @page_type = raw_page.type
    @page_raw_data = raw_page.content
  end

  def show
    @tmptr.box_addstr(self.to_aa(@tmptr.font_size), @tmptr.init_x, @tmptr.init_y)
  end

  def to_aa(font_size=12)
    temp = Tempfile.new("termpresenter-image-buf")
    temp.binmode
    case @page_type
    when :"text/plain"
      return @page_raw_data.to_aa(font_size)
    when :"image/png"
      temp.write(@page_raw_data)
      temp.close
      return %x{cat #{temp.path}| pngtopnm | ppmtopgm | pgmtopbm | pbmtoascii}
    when :"image/jpeg"
      temp.write(@page_raw_data)
      temp.close
      return %x{cat #{temp.path}| jpegtopnm | ppmtopgm | pgmtopbm | pbmtoascii}
    when :"image/jpeg"
      temp.write(@page_raw_data)
      temp.close
      return %x{cat #{temp.path}| giftopnm | ppmtopgm | pgmtopbm | pbmtoascii}
    else
      p self if $DEBUG
      return "nil"
    end
  end

end

class Tmptr_window_core
  attr_writer :lines, :infobar_proc, :contents_color
  attr_reader :current_index, :init_x, :init_y, :font_size

  def initialize(content)
    @content = content
    @current_index = 0
    @lines = 4
    @real_lines = 0
    @real_cols = 0
    @font_size = 12
    @init_x = 2
    @init_y = 2
    @contents_color = 30
    @infobar_proc = Proc.new{}
  end

  def setup()
    @term.clear
    @term.box(?|, ?-, ?*)
    @infobar_proc.call(self, @content)
    @term.refresh
  end

  def infobar(str)
    @term.setpos(0, 0)
    @term.addstr(str)
  end

  def reflesh()
    view(@current_index)
  end

  def reload(content)
    @content = content
    reflesh
  end

  def view(index)
    index = (index % @content.pages)
    @current_index = index
    @term.clear
    setup
    slide = Tmptr_slide.new(self, @content.get_page(index))
    slide.show
    @term.setpos(0, 0)
    @term.refresh
  end

  def box_addstr(str, x, y)
    i = y
    str.split("\n").each{|line|
      @term.setpos(i, x)
      @term.addstr(line[0, @real_cols-5])
      i = i + 1
    }
  end

  def next()
    view(@current_index + 1)
  end

  def prev()
    view(@current_index - 1)
  end

  def toggle_strong()
    if @standout == true
      Curses.standend
    else
      Curses.standout
    end
    @standout = ! @standout
  end

  def start(&block)
    view(0)
    while true
      block.call(@term, @term.getch)
    end
  end

  def calc_fontsize
    need_lines = 0
    ret = 6
    while  need_lines < @real_lines
      need_lines = ("あ\n" * @lines.to_i).to_aa(ret).split(/\n/).size + 9
      ret = ret + 1
    end
    return ret
  end

end

class Tmptr < Tmptr_window_core
  def initialize(content)
    super
    Curses.init_screen
    Curses.noecho
    @term = Curses.stdscr
  end

  def setup
    super
    if @real_lines != Curses.lines or @real_cols != Curses.cols
      @real_lines = Curses.lines
      @real_cols = Curses.cols
      @font_size = calc_fontsize
    end
  end

  def execute_command()
    sub = Tmptr_command_window.new(@term, 3, 30, 4, 4)
    sub.setup
    Curses.echo
    @term.setpos(5, 6)
    command = @term.getstr
    Curses.noecho
    sub.close
    reflesh
    sub = Tmptr_result_window.new(@term, 30, 30, 4, 4)
    sub.setup
    @term.setpos(5, 5)
    ret = %x{#{command.chomp} | cut -b '1-28'}.split(/\n/)[0,26].join("\n") + "\n enter key"
    box_addstr(ret, 5, 5)
    @term.getstr
    sub.close
    reflesh
  end

end


class Tmptr_sub_window_core < Tmptr_window_core
  attr_accessor :lines, :cols

  def initialize(parent, height, width, y, x)
    @infobar_proc = Proc.new{}
    @parent = parent
    @term = parent.subwin(height, width, y, x)
  end

  def close()
    @term.close
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

