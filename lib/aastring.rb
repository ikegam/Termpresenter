#!/usr/bin/ruby
# このふぁいるはうーてーえふはちです。

class String
  require 'pango'
  require 'tempfile'

  def to_aa(height=400)
    ret = ""
    self.split(/\n/).each{|line|
      surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, height, 18)
      context = Cairo::Context.new(surface)
      context.set_source_rgb(1, 1, 1)
      context.rectangle(0, 0, height, 18)
      context.fill
      context = Cairo::Context.new(surface)
      layout = context.create_pango_layout
      layout.text = line
      layout.width = height * Pango::SCALE
      context.show_pango_layout(layout)
      temp = Tempfile.new("termpresenter", "/tmp")
      surface.write_to_png(temp.path)
      ret = ret + %x{cat #{temp.path}| pngtopnm | ppmtopgm | pgmtopbm | pbmtoascii}
    }
    return ret
  end
end

if $0 == __FILE__
  "ああああ\nあああ\n池上洋行\nあいうえお".to_aa.split(/\n/).each{|line| puts line }
end

