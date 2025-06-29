#!/usr/bin/env ruby

class Tmptr_raw_page

  require 'mime/types'

  attr_reader :content
  attr_reader :type

  def initialize(file)
    @type = MIME::Types.type_for(file)[0].to_s.to_sym
    case @type
    when :"text/plain"
      @content = open(file).read
    else
      @content = open(file, "rb").read
    end
  end

end

class Tmptr_content
  attr_reader :pages

  def self.new_bydir(dir)
    files = Dir.entries(dir).sort.map{|x| File.expand_path(x, dir)}.select{|x| File.ftype(x) == "file"}
    self.new(files)
  end

  def initialize(files)
    @files = files
    @pages = files.size
  end

  def get_page(index)
    return Tmptr_raw_page.new(@files[index])
  end

  def get_file_path(index)
    return @files[index]
  end


end

if $0 == __FILE__
  content = Tmptr_content.new_bydir("../presen")
  p content.get_page(0)
  p content.pages
end

