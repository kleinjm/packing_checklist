class WunderlistClient
  require 'wunderlist'

  LIST_NAME = "Packing"

  def initialize
    @wl = init_client
  end

  def create_task(name)
    task = @wl.new_task(LIST_NAME, {:title => name, :completed => false})
    task.save
  end

  def init_client
    Wunderlist::API.new({
      :access_token => WL_ACCESS_TOKEN,
      :client_id => WL_CLIENT_ID
    })
  end
end
