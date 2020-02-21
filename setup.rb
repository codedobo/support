# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def setup
    send_message "\u001b[96mSet up up support module..."
    @client.query("CREATE TABLE IF NOT EXISTS `support` (
      `SERVERID` bigint(255) NOT NULL,
      `CHANNEL` bigint(255) NOT NULL,
      `ROLE` bigint(255) NOT NULL,
      PRIMARY KEY  (`SERVERID`)
    );")
    send_message "\u001b[32mSuccessfully set up uno module!"
  end

  def join(server, _already)
    send_message "\u001b[96mSet up uno module for #{server.id}..."
    id = server.id
    theme = 'default'
    @client.query("INSERT INTO `uno` VALUES (#{id},'#{theme}',NULL) ON DUPLICATE KEY UPDATE THEME='#{theme}';")
    send_message "\u001b[32mSuccessfully set up uno module for #{server.id}!"
  end

  def reload(server)
    send_message "\u001b[96mReloading uno module for server #{server.name}(#{server.id})..."
    match_making
    send_message "\u001b[32mSuccefully reloaded the uno module for the server!"
  end
end
