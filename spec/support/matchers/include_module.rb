# Define a custom RSpec matcher called `include_module`.
# This matcher checks if a model includes a specified module.
RSpec::Matchers.define :include_module do |expected_module|
  match do |model|
    # @param expected_module [Module] The module that should be included in the model.
    # @return [Boolean] True if the model's ancestors include the expected module, false otherwise.
    model.class.included_modules.include?(expected_module)
  end

  # Failure message when the matcher fails.
  failure_message do |model|
    # @return [String] The failure message to be displayed if the model does not include the expected module.
    "expected #{model.class} to include the module #{expected_module}"
  end

  # Failure message when the matcher is negated.
  failure_message_when_negated do |model|
    # @return [String] The failure message to be displayed if the model includes the module unexpectedly.
    "expected #{model.class} not to include the module #{expected_module}"
  end

  # Provide a description of the matcher for documentation or output.
  description do
    # @return [String] A description of the matcher.
    "include the module #{expected_module}"
  end
end
