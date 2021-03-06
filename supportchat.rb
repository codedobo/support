# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support
    @module_manager.bot.discord.message do |event|
      if !event.user.bot_account? && !@client[:support_chats].first(server_id: event.server.id, chat: event.channel.id).nil?
        if event.server.online_members(include_idle: false, include_bots: false).select do |member|
          @client[:support_roles].where(server_id: event.server.id).each do |row|
            member.role?(row[:role])
          end
        end.length <= 0
          event.send_message @language.get_json(event.server.id)['event']['notonline']
        end
      end
    end
  end
  
  def notification
    @module_manager.bot.discord.message do |event|
      if !event.user.bot_account? && !@client[:support_notifications].first(server_id: event.server.id, chat: event.channel.id).nil? && 
        (!event.server.online_members(include_idle: false, include_bots: false).select do |member|
          @client[:support_roles].where(server_id: event.server.id).each do |row|
            member.role?(row[:role])
          end
        end.empty?)
        event.message.delete
        event.channel.send_embed do |embed|
          embed.title = format(@language.get_json(event.server.id)['event']['online']['title'], u: event.user.name)
          embed.color = @language.get_json(event.server.id)['event']['online']['color']
          embed.description = event.message.content
        end
      end
    end
  end
end
