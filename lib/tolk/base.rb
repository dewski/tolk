module Tolk
  class Base
    class << self
      def key(*args)
        Tolk.key(*args)
      end
    end
    
    def key(*args)
      Tolk.key(*args)
    end
  end
end
