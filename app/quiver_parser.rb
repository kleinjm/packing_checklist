# frozen_string_literal: true

require "benchmark"
require_relative "../lib/wunderlist_client"
require_relative "./note_parser"

class QuiverParser
  ITEM_PREFIX = ENV.fetch("ITEM_PREFIX") do
    Regexp.new(/\- \[ \]/)
  end
  TITLE_PREFEX = ENV.fetch("TITLE_PREFEX") do
    Regexp.new(/### /)
  end

  def initialize
    @wunderlist = WunderlistClient.new
    @items_added_count = 0
  end

  def export
    print_lists_with_indexes
    receive_indexes_input

    time = Benchmark.measure { add_packing_items }
    print_success_message(time: time.real.round)
  end

  private

  attr_reader :wunderlist, :list_indexes
  attr_accessor :items_added_count

  def add_packing_items
    puts "Adding packing items"
    add_items_for_list(index: 0) # Vital
    list_indexes.each { |index| add_items_for_list(index: index) }
  end

  def add_items_for_list(index:)
    list_items.values[index].each do |item|
      print "."
      wunderlist.create_task(item)
      @items_added_count += 1
    end
  end

  def receive_indexes_input
    puts <<~HEREDOC
      Which checklists would you like to include?
      Vital items are automatically included.
      Leave blank to only add vital items.
      Type 'exit' to quit.
      Please comma delimit list numbers. Ie. 1,3,5
    HEREDOC
    input = gets
    exit if input.match? "exit" # rubocop:disable Rails/Exit
    @list_indexes = input.delete("\n").split(",").map(&:to_i)
  end

  def print_lists_with_indexes
    list_items.each_with_index do |(list_name, items), i|
      next if i.zero? # Vital is always included
      puts "#{i} - #{list_name} (#{items.size} items)"
    end
  end

  def list_items
    return @list_items if defined?(@list_items)
    @list_items = build_list_items_hash
  end

  # rubocop:disable Metrics/MethodLength
  def build_list_items_hash
    title = ""
    NoteParser.new.note_lines.each_with_object({}) do |line, res|
      if line.match? TITLE_PREFEX
        title = line.gsub(TITLE_PREFEX, "").delete("\n").strip
        res[title] = []
        next
      end
      if line.match? ITEM_PREFIX
        res[title] << line.gsub(ITEM_PREFIX, "").delete("\n").strip
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def print_success_message(time:)
    puts "\nAdded #{items_added_count} items in #{time} seconds"
  end
end
