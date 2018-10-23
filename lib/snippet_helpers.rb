module SnippetHelpers
  def xsd(name)
    root = Middleman::Application.root
    file_path = File.join(root, 'source',"#{name}.xsd")
    return "```\n#{File.read(file_path)}```"
  end

  def xml(name)
    root = Middleman::Application.root
    file_path = File.join(root, 'source',"#{name}.xml")
    return "```\n#{File.read(file_path)}```"
  end
end
