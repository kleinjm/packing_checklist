# frozen_string_literal: true

require "bundler/setup"
require "wunderlist"
require "active_support/core_ext/numeric/time"

class WunderlistClient
  LIST_NAME = ENV.fetch("LIST_NAME") do
    "Packing"
  end.freeze

  def initialize
    @wl = init_client
  end

  def create_task(name)
    task = @wl.new_task(
      LIST_NAME,
      title: name,
      completed: false,
      due_date: Time.current.to_date
    )
    task.save
  end

  def init_client
    Wunderlist::API.new(
      access_token: ENV.fetch("WL_ACCESS_TOKEN"),
      client_id: ENV.fetch("WL_CLIENT_ID")
    )
  end
end
