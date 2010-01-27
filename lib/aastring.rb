#!/usr/bin/ruby
# このふぁいるはうーてーえふはちです。

class String
  require 'pango'
  require 'tempfile'

  def to_aa(height=12)
    ret = ""
    self.split(/\n/).each{|line|
      surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, 400, height + (height/3).to_f)
      context = Cairo::Context.new(surface)
      context.set_source_rgb(1, 1, 1)
      context.rectangle(0, 0, 400, height + (height/3).to_f)
      context.fill
      context = Cairo::Context.new(surface)
      layout = context.create_pango_layout
      layout.text = line
      layout.font_description = "Sans #{height}"
      layout.width = 400 * Pango::SCALE
      context.show_pango_layout(layout)
      temp = Tempfile.new("termpresenter", "/tmp")
      surface.write_to_png(temp.path)
      ret = ret + %x{cat #{temp.path}| pngtopnm | ppmtopgm | pgmtopbm | pbmtoascii}
      temp.close
    }
    return ret
  end
end

if $0 == __FILE__
  puts "ああああ".to_aa.split(/\n/).size + 1
  puts "ああああ".to_aa(13).split(/\n/).size + 1
  puts "ああああ".to_aa(14).split(/\n/).size + 1
  puts "ああああ".to_aa(15).split(/\n/).size + 1
  puts "ああああ".to_aa(16).split(/\n/).size + 1
  puts "ああああ".to_aa(17).split(/\n/).size + 1
  puts "ああああ".to_aa(18).split(/\n/).size + 1
  puts "ああああ".to_aa(18)
  puts "ああああ".to_aa(30)
end
