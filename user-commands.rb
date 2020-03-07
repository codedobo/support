# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support_commands
    @app_class.register_user_cmd(:support, ['support', 'sup', 'spprt', 'supp']) do |_command, args, event|
      unless event.author.permission? :manage_server
        event.send_message @language.get_json(event.server.id)['commands']['nopermission']
        return
      end
      if args.length == 0
        event.channel.send_embed do |embed|
          embed.title = 'Test'
        end
      elsif args.length == 1 || args.length == 3
        if args[0] == 'set'
          if args.length == 3
            channel = event.bot.channel(args[2].to_i, event.server)
            if channel && channel.server.id == event.server.id
              @client.query("REPLACE into `support`(SERVERID, ROLE, CHANNEL) VALUES ('#{@client.escape(event.server.id.to_s)}', '#{@client.escape(args[1])}', '#{channel.id.to_s}');")
              event.send_message @language.get_json(event.server.id)['commands']['set']['success']
            else
              event.send_message @language.get_json(event.server.id)['commands']['set']['invalid']
            end
          else
            @client.query("DELETE FROM `support` WHERE SERVERID=#{event.server.id};")
            event.send_message @language.get_json(event.server.id)['commands']['set']['delete']
          end
        else
          event.send_message @language.get_json(event.server.id)['commands']['set']['usage']
        end
      else
        event.send_message @language.get_json(event.server.id)['commands']['usage']
      end
    end
  end
  def help(_user, channel)
    command_language = @language.get_json(channel.server.id)['commands']['help']
    channel.send_embed do |embed|
      embed.title = command_language['title']
      embed.description = command_language['description']
      embed.timestamp = Time.now
      embed.color = command_language['color']
    end
  end
end
