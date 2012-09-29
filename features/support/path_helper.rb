module PathHelpers
  def format_path(path)
    path.gsub!(/\s/,'_').downcase!
  end
end
World(PathHelpers)
