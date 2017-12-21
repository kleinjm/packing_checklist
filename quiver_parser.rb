class QuiverParser
  ITEM_PREFIX = Regexp.new(/\- \[ \]/)

  def initialize(file_path:)
    @file_path = file_path
  end

  def tasks(list_name: "all")
    in_list = false
    File.read(file_path).lines.each_with_object([]) do |line, res|
      in_list = line.include?(list_name) if line.match?(/###/)

      if (in_list || list_name == "all") && line =~ ITEM_PREFIX
        res << line.gsub("- [ ]", "").delete("\n")
      end
    end
  end

  private

  attr_reader :file_path
end
