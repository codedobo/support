# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def join(server, _already)
    send_message "\u001b[96mSet up support module for #{server.id}..."
    id = server.id
    send_message "\u001b[32mSuccessfully set up support module for #{server.id}!"
  end

  def reload(server)
    send_message "\u001b[96mReloading support module for server #{server.name}(#{server.id})..."
    send_message "\u001b[32mSuccefully reloaded the support module for the server!"
  end

  def setup
    @client.create_table? :support_chats do
      Bignum :server_id
      Bignum :chat
    end
    @client.create_table? :support_roles do
      Bignum :server_id
      Bignum :role
    end
    @client.create_table? :support_notifications do
      Bignum :server_id
      Bignum :chat
    end
  end
end
