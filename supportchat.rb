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
    @module_manager.bot.discord.presence do |event|
      member = event.server.member(event.user.id)
      if !event.user.bot_account? && event.status == :online && !@client[:support_roles].where(server_id: event.server.id).each do |row|
        member.role?(row[:role])
      end.empty?
        @client[:support_notifications].where(server_id: event.server.id).each do |row|
          event.bot.channel(row[:chat]).send_embed do |embed|
            embed.title = @language.get_json(event.server.id)['event']['online']['title']
            embed.description = format(@language.get_json(event.server.id)['event']['online']['body'], u: event.user.mention)
          end
        end
      end
    end
  end
end
