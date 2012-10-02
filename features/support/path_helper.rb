module PathHelpers
  def format_path(path)
    path.match(/\s+/) ? path.gsub!(/\s+/,"_") : path
    path.downcase!
  end
end
World(PathHelpers)
