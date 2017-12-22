# frozen_string_literal: true

class WunderlistClient
  require "wunderlist"

  DEFAULT_LIST_NAME = "Packing"

  def initialize
    @wl = init_client
  end

  def create_task(name)
    list_name = ENV.fetch("LIST_NAME", DEFAULT_LIST_NAME)
    task = @wl.new_task(list_name, title: name, completed: false)
    task.save
  end

  def init_client
    Wunderlist::API.new(
      access_token: ENV.fetch("WL_ACCESS_TOKEN"),
      client_id: ENV.fetch("WL_CLIENT_ID"),
    )
  end
end
