# frozen_string_literal: true

require "json"

class NoteParser
  CHECKLIST_NAME = ENV.fetch("CHECKLIST_NAME") do
    Regexp.new(/Packing Checklist/)
  end
  CONTENT_FILENAME = Regexp.new(/content\.json/)
  DIRPATH = ENV.fetch("NOTEBOOK_DIR") do
    "/Users/jklein/Dropbox/quiver.qvlibrary"
  end
  NOTEBOOK_EXT = Regexp.new(/\.qvnotebook/)
  NOTE_EXT = Regexp.new(/\.qvnote/)

  def note_lines
    checklist_json = find_notebook(directory: DIRPATH)
    JSON.parse(checklist_json)["cells"][0]["data"].lines
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
