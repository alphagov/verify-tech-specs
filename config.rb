require 'govuk_tech_docs'

GovukTechDocs.configure(self, livereload: { js_host: "localhost" })
require "lib/snippet_helpers"
helpers SnippetHelpers

%w{xsd xml plantuml}.each do |ext|
  ignore "**/*.#{ext}"
end
