module SnippetHelpers
  def xml(rel_path)
    root = Middleman::Application.root
    base_path = caller_locations.first.path
    file_path = File.join(root, 'source', File.dirname(base_path),"#{rel_path}.xml")
    return "```\n#{File.read(file_path)}```"
  end

  def inline_svg(image_path, optional_attributes = {})
    image_path = File.join(root, 'source',"#{image_path}.svg")

    # If the image was found...
    if File.exists?(image_path)
      File.read(image_path)
    else
      # Embed an inline SVG image with an error message
      %(
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 30"
          width="400px" height="30px"
        >
          <text font-size="16" x="8" y="20" fill="#cc0000">
            Error: '#{image_path}' could not be found.
          </text>
          <rect
            x="1" y="1" width="398" height="28" fill="none"
            stroke-width="1" stroke="#cc0000"
          />
        </svg>
      )
    end
  end
end
