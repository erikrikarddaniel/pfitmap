# Load the rails application
require File.expand_path('../application', __FILE__)

ActiveSupport::Inflector.inflections do |inflection| inflection.irregular "criterion", "criteria"
end

# Initialize the rails application
Pfitmap::Application.initialize!

#My MIME types
Mime::Type.register "text/plain", :fasta
Mime::Type.register "text/plain", :gb

