#!/usr/bin/ruby

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

  def get_content(index)
    index = (index % @pages)
    return open(@files[index]).read
  end

  def get_file_path(index)
    index = (index % @pages)
    return @files[index]
  end


end

if $0 == __FILE__
  content = Tmptr_content.new_bydir("../presen")
  p content.get_content(0)
  p content.pages
end
