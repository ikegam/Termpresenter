#!/usr/bin/env ruby
# このふぁいるはうーてーえふはちです。

class String
  attr_writer :aafont
  require 'pango'
  require 'tempfile'

  def initialize
    super
    @aafont = "IPAGothic"
  end

  def to_aa(height = 12)
    each_line.reduce(+'') do |buf, line|
      surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, 400, height + (height / 3.0))
      context = Cairo::Context.new(surface)
      context.set_source_rgb(1, 1, 1)
      context.rectangle(0, 0, 400, height + (height / 3.0))
      context.fill
      context = Cairo::Context.new(surface)
      layout = context.create_pango_layout
      layout.text = line.chomp
      layout.font_description = "#{@aafont} #{height}"
      layout.width = 400 * Pango::SCALE
      context.show_pango_layout(layout)
      Tempfile.open('termpresenter', '/tmp') do |temp|
        surface.write_to_png(temp.path)
        buf << %x{cat #{temp.path}| pngtopnm | ppmtopgm | pgmtopbm | pbmtoascii}
      end
      buf
    end
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
