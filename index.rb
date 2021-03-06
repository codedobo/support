# frozen_string_literal: true

require_relative './user-commands.rb'
require_relative './setup.rb'
require_relative './supportchat.rb'
class SupportModule
  include CodeDoBo::BotModule

  def initialize(app_class, module_manager)
    @module_manager = module_manager
    @app_class = app_class
    send_message "\u001b[36mStarting support module..."
    @client = module_manager.client
    @language = CodeDoBo::Language.new(module_manager.client, __dir__ + '/language')
    setup
    support_commands
    support
    notification
    send_message "\u001b[32mSuccessfully started support module!"
  end
end
