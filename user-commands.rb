# frozen_string_literal: true

require_relative './index.rb'
class SupportModule
  def support_commands
    @app_class.register_user_cmd(:support, %w[support sup spprt supp]) do |_command, args, event|
      language = @language.get_json(event.server.id)['commands']
      if event.author.permission? :manage_server
        if args.length <= 0
          language = language['help']
          event.channel.send_embed do |embed|
            embed.title = language['title']
            embed.description = language['description']
            embed.color = language['color']
          end
        elsif args[0].casecmp('role').zero?
          role_subcommand(args, event)
        elsif args[0].casecmp('chat').zero?
          chat_subcommand(args, event)
        elsif args[0].casecmp('notification').zero?
          notification_subcommand(args, event)
        else
          event.send_message language['usage']
        end
      else
        event.send_message language['nopermission']
      end
    end
  end

  def role_subcommand(args, event)
    language = @language.get_json(event.server.id)['commands']['role']
    if args.length <= 1
      event.channel.send_embed do |embed|
        embed.title = language['information']['title']
        roles = @client[:support_roles].where(server_id: event.server.id).map { |h| event.server.role(h[:role]).mention }.join(language['information']['delimiter'])
        embed.description = format(language['information']['description'], r: roles)
      end
    elsif args[1].casecmp('add').zero?
      if args.length == 3
        if event.server.role(args[2]) && @client[:support_roles].first(server_id: event.server.id, role: args[2]).nil?
          @client[:support_roles].insert(server_id: event.server.id, role: args[2])
          event.send_message language['success']
        else
          event.send_message language['invalid']
        end
      else
        event.send_message language['usage']
      end
    elsif args[1].casecmp('remove').zero?
      if args.length == 3
        @client[:support_roles].where(server_id: event.server.id, role: args[2]).delete
        event.send_message language['delete']
      else
        event.send_message language['usage']
      end
    else
      event.send_message language['usage']
    end
  end

  def chat_subcommand(args, event)
    language = @language.get_json(event.server.id)['commands']['chat']
    if args.length <= 1
      event.channel.send_embed do |embed|
        embed.title = language['information']['title']
        chats = @client[:support_chats].where(server_id: event.server.id).map { |h| @module_manager.bot.discord.channel(h[:chat]).mention }.join(language['information']['delimiter'])
        embed.description = format(language['information']['description'], c: chats)
      end
    elsif args[1].casecmp('add').zero?
      if args.length == 3
        if @module_manager.bot.discord.channel(args[2], event.server.id) && @client[:support_chats].first(server_id: event.server.id, chat: args[2]).nil?
          @client[:support_chats].insert(server_id: event.server.id, chat: args[2])
          event.send_message language['success']
        else
          event.send_message language['invalid']
        end
      else
        event.send_message language['usage']
      end
    elsif args[1].casecmp('remove').zero?
      if args.length == 3
        @client[:support_chats].where(server_id: event.server.id, chat: args[2]).delete
        event.send_message language['delete']
      else
        event.send_message language['usage']
      end
    else
      event.send_message language['usage']
    end
  end

  def notification_subcommand(args, event)
    language = @language.get_json(event.server.id)['commands']['notifications']
    if args.length <= 1
      event.channel.send_embed do |embed|
        embed.title = language['information']['title']
        chats = @client[:support_notifications].where(server_id: event.server.id).map { |h| @module_manager.bot.discord.channel(h[:chat]).mention }.join(language['information']['delimiter'])
        embed.description = format(language['information']['description'], c: chats)
      end
    elsif args[1].casecmp('add').zero?
      if args.length == 3
        if @module_manager.bot.discord.channel(args[2], event.server.id) && @client[:support_notifications].first(server_id: event.server.id, chat: args[2]).nil?
          @client[:support_notifications].insert(server_id: event.server.id, chat: args[2])
          event.send_message language['success']
        else
          event.send_message language['invalid']
        end
      else
        event.send_message language['usage']
      end
    elsif args[1].casecmp('remove').zero?
      if args.length == 3
        @client[:support_notifications].where(server_id: event.server.id, chat: args[2]).delete
        event.send_message language['delete']
      else
        event.send_message language['usage']
      end
    else
      event.send_message language['usage']
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
