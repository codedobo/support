# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support
    @app_class.module_manager.bot.discord.message do |event|
        results = @client.query("SELECT * FROM `support` WHERE SERVERID='#{event.server.id}';")
        return if event.author.bot_account?
        return if results.size != 1
        return if results.first['CHANNEL'] != event.channel.id
        event.server.online_members(include_idle: false, include_bots: false).each do |member|
            return if member.role? results.first['ROLE']
        end
        event.send_message @language.get_json(event.server.id)['event']['notonline']
    end
  end
end
