module Errors
  class StandardServiceError < StandardError
    attr_reader :code, :details

    def initialize(message:, code:, details:)
      @code = code
      @details = details
      super(message)
    end
  end
end
