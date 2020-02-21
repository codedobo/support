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
    send_message "\u001b[32mSuccessfully set up support module!"
  end

  def join(server, _already)
    send_message "\u001b[96mSet up support module for #{server.id}..."
    id = server.id
    theme = 'default'
    @client.query("INSERT INTO `support` VALUES (#{id},'#{theme}',NULL) ON DUPLICATE KEY UPDATE THEME='#{theme}';")
    send_message "\u001b[32mSuccessfully set up support module for #{server.id}!"
  end

  def reload(server)
    send_message "\u001b[96mReloading support module for server #{server.name}(#{server.id})..."
    match_making
    send_message "\u001b[32mSuccefully reloaded the support module for the server!"
  end
end
