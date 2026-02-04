module BaseService
  attr_reader :errors, :valid

  def valid?
    @valid
  end

private

  def set_as_invalid!
    @valid = false
  end

  def set_as_valid!
    @valid = true
  end

  def set_errors(errors)
    Rails.logger.error({ service: self.class, errors: errors }.to_json) unless Rails.env.test?
    @errors = errors
  end
end
