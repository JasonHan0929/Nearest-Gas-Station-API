module CustomedError
  class ParsingException < StandardError
    attr_reader :error_info
    def initialize(data)
      @error_info = data
    end
  end
end