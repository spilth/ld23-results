require 'csv'

file = "results.csv"

columns = %w(date languages engine library image_editor sound_editor username title entry_url completed music_editor level_editor timelapse_tool operating_system model_editor timelapse_url postmortem_url valid)

count_columns = %w(languages engine library image_editor sound_editor music_editor level_editor timelapse_tool operating_system model_editor)

synonym_map = {
  "actionscript" => ["as3", "actionscript 3", "action script", "actionscript 3.0", "actionscript3", "flash/flexsdk", "flash / actionscript 3", "actionscript3 (flash)", "action script 3", "as3 - using flashdevelop ide", "flash", "Flash/FlexSDK"],
  "javascript" => ["javascript/html", "javascript (unityscript)", "javascrip", "java/javascript", "unityscript (javascript)", "unityscript"],
  "java" => ["java 7", "processing/java", "processing"],
  "gamemaker" => ["game maker language", "game maker", "gml", "GameMaker Sprite Editor"],
  "c#" => ["c# in unity 3d."],
  "coffeescript" => ["coffeescript/javascript"],
  "stencyl" => ["stencyl (flash)", "stencyl design mode", "stencyl/as3"],
  "garage band" => ["garageband"],
  "gml" => ["game maker", "game maker language", "game maker language(gml)", "gamemaker", "gamemaker gml", "None (well i used Game Maker's built in language but that's not really programming)"],
  "c++" => ["Tried for C++. Failed."],
  "blender game engine" => ["BGE (Blender Game Engine)"],
  "flatredball" => ["Flat Red Ball"],
  "love" => ["LOVE 2D", "Love2d", "L\u00F6VE", "L\u00F6ve/Love2d", "L\u00F6ve2D"],
  "Multimedia Fusion" => ["Multimedia Fusion 2"],
  "Allegro 5" => ["Allegro"],
  "CraftyJS" => ["craftyjs"],
  "flashpunk" => ["Flash Punk"],
  "slick2d" => ["slick"],
  "sfml" => ["sfml2", "sfml 1.6"],
  "sdl" => ["Standard Directmedia Layer (SDL)"],
  "xna" => ["xna 4.0"],
  "graphicsgale" => ["Graphics Gale", "GraphicsGale freeedition"],
  "MS Paint" => ["Microsoft Paint", "Microsoft XP Paint", "MS Paint 6.1", "MSPaint", "Paint"],
  "Paint Shop Pro" => ["Paint Shop Pro 7", "Paint Shop Pro 7.04", "Paint Shop Pro X2"],
  "Photoshop" => ["Photoshop CS3", "Photoshop CS6"],
  "Adobe Audition" =>  ["Adobe Audition 3.0"],
  "Aviary" => ["Aviary Music Creator (Roc)", "Aviary's Music Editor"],
  "FL Studio" => ["Fl Studio", "FL Studio (Free)", "FLStudio", "fruity loops", "FruityLoops"],
  "Linux Multi Media Studio" => ["Linux MultiMedia Studio"],
  "LSDJ" => ["LSDJ for Gameboy"],
  "Modplug" => ["Modplug Tracker"],
  "WolframTones" => ["Wolfram tones", "WolframTunes"]
}

$replacements = {}
synonym_map.each_pair do |key, synonyms|
  synonyms.each do |synonym|
    $replacements[synonym] = key
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
    values.each {|value| value = get_real_value(value)}
    entry[name] = values
    values.each do |value|
      value = get_real_value(value)
      if !answers[name][value].nil?
        answers[name][value] += 1
      else
        answers[name][value] = 1
      end
    end
  end
  entries << entry
end

#puts "Entries:"
#puts entries

count_columns.each do |key|
  puts "## #{key}"
  sorted = answers[key.to_sym].sort_by {|key, value| value}
  sorted.reverse.each do |tuple|
    puts "- #{tuple[0]}: #{tuple[1]}"
  end
  puts
end



