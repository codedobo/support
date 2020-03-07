# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support
    @app_class.module_manager.bot.discord.message do |event|
      results = @client[:main].find(server_id: event.server.id)
      if !event.user.bot_account? && results.size == 1 && results.first['CHANNEL'] == event.channel.id
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
      results = @client[:main].find(server_id: event.server.id)
      if !event.user.bot_account? && event.status == :online && results.size == 1 && event.user.on(event.server).role?(results.first['ROLE'])
        event.bot.channel(results.first['CHANNEL']).send_embed do |embed|
          embed.title = @language.get_json(event.server.id)['event']['online']['title']
          embed.description = format(@language.get_json(event.server.id)['event']['online']['body'], event.user.name)
        end
      end
    end
  end
end
