# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support
    @app_class.module_manager.bot.discord.message do |event|
      results = @client.query("SELECT * FROM `support` WHERE SERVERID='#{event.server.id}';")
      if (!event.user.bot_account? && results.size == 1 && results.first['CHANNEL'] == event.channel.id)
        if event.server.online_members(include_idle: false, include_bots: false).select do |member|
          member.role?(results.first['ROLE'])
        end.length <= 0
          event.send_message @language.get_json(event.server.id)['event']['notonline']
        end
      end
    end
  end
  def notification
    @app_class.module_manager.bot.discord.presence do |event|
        results = @client.query("SELECT * FROM `support` WHERE SERVERID='#{event.server.id}';")
        if (!event.user.bot_account? && event.status == :online && results.size == 1 && event.user.role?(results.first['ROLE']))
            event.bot.send_message(results.first['CHANNEL'], format(@language.get_json(event.server.id)['event']['online'], u: event.user.mention))
        end
    end
  end
end
