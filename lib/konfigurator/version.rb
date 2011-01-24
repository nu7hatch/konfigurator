module Konfigurator
  module Version # :nodoc:
    MAJOR  = 0
    MINOR  = 2
    PATCH  = 0
    STRING = [MAJOR, MINOR, PATCH].join('.')
  end
  
  def self.version # :nodoc:
    Version::STRING
  end
end # Konfigurator
