require 'csv'
require 'gruff'
require 'yaml'

file = "results.csv"

# true = countable, false = don't count
column_configuration = {
  :date => false,
  :languages => true,
  :engine => true,
  :library => true,
  :image_editor => true,
  :sound_editor => true,
  :username => false,
  :title => false,
  :entry_url => false,
  :completed => false,
  :music_editor => true,
  :level_editor => true,
  :timelapse_tool => true,
  :operating_system => true,
  :model_editor => true,
  :timelapse_url => false,
  :postmortem_url => false,
  :valid => false
}

columns = column_configuration.keys.map {|key| key.to_s}
count_columns = column_configuration.select {|key, value| value}.keys.map {|key| key.to_s}

synonym_map = YAML.load_file("synonyms.yml")

replacements = {}
synonym_map.each_pair do |key, synonyms|
  synonyms.each do |synonym|
    replacements[synonym.downcase] = key.downcase
  end
end

def get_real_value(value)
  if $replacements.has_key?(value)
    value = $replacements[value]
  else
    value = value
  end
end

column_names = {}

columns.each_with_index do |name, index|
  column_names[index] = name.to_sym
end

entries = []
answers = {}

column_names.each do |index, name|
  answers[name] = {}
end

CSV.foreach(file, {:headers => true}) do |row|
  entry = {}
  column_names.each do |index, name|
    value = row[index] || ""
    values = value.split(",")
    values.each {|value| value.strip!}
    values.each {|value| value.downcase!}
    values.each do |value|
      if replacements.has_key?(value)
        value = replacements[value]
      else
        value = value
      end
    end
    entry[name] = values
    values.each do |value|
      if !answers[name][value].nil?
        answers[name][value] += 1
      else
        answers[name][value] = 1
      end
    end
  end
  entries << entry
end

count_columns.each do |key|
  g = Gruff::Bar.new(1280)
  g.hide_legend = true
  g.title = key
  g.x_axis_label = "Count"
  g.y_axis_label = "Tool"
  puts "## #{key}"
  sorted = answers[key.to_sym].sort_by {|key, value| value}
  sorted.reverse.each do |tuple|
    puts "- #{tuple[0]}: #{tuple[1]}"
    g.data(tuple[0], tuple[1])
  end
  puts
  g.write("#{key}.png")
end

