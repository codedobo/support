# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support
    @app_class.module_manager.bot.discord.message do |event|
        results = @client.query("SELECT * FROM `support` WHERE SERVERID='#{event.server.id}';")
        return if results.size != 1
        puts '1'
        return if results.first['CHANNEL'] != event.channel.id
        puts '2'
        event.server.online_members(include_idle: false, include_bots: false).each do |member|
            return if member.role? results.first['ROLE']
            puts 'next'
        end
        puts '3'
        event.send_message @language.get_json(event.server.id)['event']['notonline']
    end
  end
end
