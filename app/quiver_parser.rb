# frozen_string_literal: true

require "json"
require "benchmark"
require_relative "../lib/wunderlist_client"

class QuiverParser
  ITEM_PREFIX = ENV.fetch("ITEM_PREFIX") do
    Regexp.new(/\- \[ \]/)
  end
  DIRPATH = ENV.fetch("NOTEBOOK_DIR") do
    "/Users/jklein/Dropbox/quiver.qvlibrary"
  end
  CHECKLIST_NAME = ENV.fetch("CHECKLIST_NAME") do
    Regexp.new(/Packing Checklist/)
  end
  CONTENT_FILENAME = Regexp.new(/content\.json/)
  NOTEBOOK_EXT = Regexp.new(/\.qvnotebook/)
  NOTE_EXT = Regexp.new(/\.qvnote/)

  def initialize
    @wunderlist = WunderlistClient.new
  end

  def export
    puts "Adding packing items"
    time = Benchmark.measure do
      list_items.each do |item|
        print "."
        wunderlist.create_task(item)
      end
    end
    puts "\nAdded #{list_items.count} items in #{time.real.round} seconds"
  end

  private

  attr_reader :wunderlist

  def list_items
    data = JSON.parse(checklist_json)["cells"][0]["data"]

    data.lines.each_with_object([]) do |line, res|
      res << line.gsub(ITEM_PREFIX, "").delete("\n") if line.match? ITEM_PREFIX
    end
  end

  def checklist_json
    find_notebook(directory: DIRPATH)
  end

  def find_notebook(directory:)
    Dir.foreach(directory) do |notebook|
      next if %w[. ..].include? notebook
      if notebook.match? NOTEBOOK_EXT
        note = find_note(directory: "#{directory}/#{notebook}")
        return note if note
      end
    end
  end

  def find_note(directory:)
    Dir.foreach(directory) do |note|
      next if %w[. ..].include? note
      if note.match? NOTE_EXT
        file = find_file(directory: "#{directory}/#{note}")
        return file if file
      end
    end
  end

  def find_file(directory:)
    Dir.foreach(directory) do |content|
      if content.match? CONTENT_FILENAME
        file = File.read("#{directory}/#{content}")
        return file if file.match? CHECKLIST_NAME
      end
    end
  end
end
