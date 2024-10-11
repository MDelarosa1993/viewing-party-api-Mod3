class ErrorSerializer
  def self.format_error(error_message, status)
    {
      message: error_message,
      status: status
    }
  end
end