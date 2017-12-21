require 'json'
require "./wunderlist_client"

class QuiverParser
  ITEM_PREFIX = Regexp.new(/\- \[ \]/)
  DIRPATH = "/Users/jklein/Dropbox/quiver.qvlibrary".freeze
  CHECKLIST_NAME = Regexp.new(/Packing Checklist/)

  def export
    wl = WunderlistClient.new
    list_items.each do |item|
      wl.create_task(item)
    end
  end

  def list_items
    data = JSON.parse(checklist_json)["cells"][0]["data"]

    res = data.lines.each_with_object([]) do |line, res|
      if line =~ ITEM_PREFIX
        res << line.gsub("- [ ]", "").delete("\n")
      end
    end
  end

  def checklist_json
    Dir.foreach(DIRPATH) do |notebook|
      next if notebook == "." || notebook == ".."
      if notebook =~ /\.qvnotebook/
        Dir.foreach("#{DIRPATH}/#{notebook}") do |note|
          next if note == "." || note == ".."
          if note =~ /\.qvnote/
            Dir.foreach("#{DIRPATH}/#{notebook}/#{note}") do |content|
              if content =~ /content\.json/
                file = File.read("#{DIRPATH}/#{notebook}/#{note}/#{content}")
                return file if file =~ CHECKLIST_NAME
              end
            end
          end
        end
      end
    end
  end
end

QuiverParser.new.export
