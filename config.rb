require 'govuk_tech_docs'

GovukTechDocs.configure(self, livereload: { js_host: "localhost" })
require "lib/snippet_helpers"
helpers SnippetHelpers
ignore '**/*.xsd'
ignore '**/*.xml'
