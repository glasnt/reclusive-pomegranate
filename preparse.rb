#!/usr/bin/env ruby
if ARGV.length == 0 then
  puts "requires an input file"
  exit 1
end

IMG_FOLDER = "images"

file = File.open(ARGV[0]).read.split("\n")

output = ARGV[1] if ARGV.length > 1

result = []

codetoggle = false

file.each do |line|
  append = ""
  type = line.split(" ").first
  if line.strip.length == 0
    result << ""
    next
  end

  content = line.split(" ")[1..-1].join(" ")

  if type.start_with?("```") then
    codetoggle = !codetoggle
  end
  
  if type.start_with?("--```") then
    codetoggle = !codetoggle
  end

  if type == "$$#" then
	content = ".righthead[#{content}]"
    type.gsub!("$$#","")
  end

  ### Vector Terminal
  ### requires Vector CSS Terminal Window CSS
  if type == "$$terminal" then ## top bar
    content = "<div class=\"shell-wrap\"><p class=\"shell-top-bar\">#{content}</p><p class=\"shell-body\">"
    type = ""
  end
   
  if type == "$$prompt" then # myrtle prefix
    content = "<ps>myrtle</ps> <dr>#{content} $</dr> "
    type = ""
  end

  if type == "$$py" then # Python Prompt
    #content = "&gt;&gt;&gt; #{content}<br>"
    content = "`>>>` #{content}<br>"
    type = ""
  end

  if type == "$$w" then # Whitespace ending
    content = "#{content}<w>&nbsp;</w>"
    type = ""
  end
  if type == "$$pyw" then # both Python Prompt and Whitespace ending
    #content = "&gt;&gt;&gt; #{content}<w>&nbsp;</w>"
    content = "`>>>` #{content}<w>&nbsp;</w>"
    type = ""
  end
  if type == "$$pd" then # Python dot dot dot 
    content = "... #{content}<br>"
    type = ""
  end
  if type == "$$pdw" then # both Python dot dot dot and Whitespace ending
    content = "... #{content}<w>&nbsp;</w><br>"
    type = ""
  end

  if type == "$$end" then
    content = "</p></p></div>"
    type = ""
  end


  # Image as the main attraction
  if type == "@^" then
    #content = "<img src=\"#{IMG_FOLDER}/#{content}\" style=\"margin-top: -50px\" />"
    content = "class: top, image\n![Image](#{IMG_FOLDER}/#{content})"
    type = ""
  end

  # Image as the main attraction, as big as you can, please
  if type == "@^^" then
    content = "class: image-main\n![Image](#{IMG_FOLDER}/#{content})"
    type = ""
  end

  # Image in the center
  if type == "@=" then
    content = "class: middle, center, image\n![Image](#{IMG_FOLDER}/#{content})"
    type = ""
  end

  # Nice Code
  if type.include? "#>" then
    content = "<pre><code>#{content}</code></pre>"
    type.gsub!("#>","")
  end

  # Shortcut for images. Assumes assets live in IMG_FOLDER/
  if type == "@" then
    content = "![Image](#{IMG_FOLDER}/#{content})"
    type.gsub!("@","")
  end

  if type == "~@" then
    append = "background-image: url(\"#{IMG_FOLDER}/#{content}\")"
    content = ""
    type = ""
  end

  if type == '~~~' then
    append = "class: background-black"
    content = ""
    type = ""
  end

  if type == '!' then
    #append = " <!-- .slide: class=\"center\" -->"
    type.gsub!("!","")
    if content.include? "|" then
	    c = "<div style='width: 100%; margin: 0 auto;'><p align='center'>"
	    l = content.split("|").length
	    a = 800 / l
	    content.split("|").each do |s|
	      t = ( s.include? "png") ? s.strip! : "#{s.strip!}.svg"
	      c += "<img height='#{a}px' src='#{IMG_FOLDER}/#{t}'>"
        end
        c += "</p></div>"
        content = c
    else 
        content = "class: middle, center\n![Image](#{IMG_FOLDER}/#{content}.svg)"
	    #content = "<div style='width: 50%; margin: 0 auto;'><p align='center'><img height='400px' src='#{IMG_FOLDER}/#{content}.svg'></p></div>"
    end
  end

  # dasfoot
  if type == "vv=" then
	content = "<span class='cfoot'>#{content}</span>"
    type.gsub!("vv=","")
  end
  if type == "vv" then
	content = ".footnotes[#{content}]"
    type.gsub!("vv","")
  end

  # PODIUM - change notes
  if type == "Note:" then
    content = "\n???\n\n#{content}\n"
    type.gsub!("Note:","")
  end

  # Ignore generic line separators
  if type == "---" then
    result << type #"---\nclass: middle, center\n"
    next
  end

  codestyles = {
    "py": "python", "rb": "ruby", "js": "javascript", "java": "java", "pl": "perl", "sh": "bash", "hs": "haskell",
    "iex": "elixir", "sc": "scala", "php": "php", "ps": "powershell",
    }  


  codestyles.keys().each do |code|
    if type.start_with? "#{code}-" then
      content = "<pre><code class=\"#{codestyles[code]}\">#{content}</code></pre>\n--\n"
      type.gsub!("#{code}-","")
    end
    if type.start_with? "#{code}" then
      content = "<pre><code class=\"#{codestyles[code]}\">#{content}</code></pre>\n"
      type.gsub!("#{code}","")
    end
  end

  # Fragment
  if type.end_with? "--" then
    result << type 
    next
  end

  # Center
  if type.include? "##=" then
    content = "class: title\n## #{content}"
    type.gsub!("##=","")
  end
  if type.include? "#=" then
    content = "class: title\n# #{content}"
    type.gsub!("#=","")
  end

  # h0
  if ["!#","!#="].include? type then
    type.gsub!("!","")
  end
   
  r = "#{type} #{content}#{append}".strip()


  if codetoggle then
    # Ignore all changes if we're in a codeblock
    newline = line
  else
    newline =  r
  end

  newline.gsub!("&lt;","`<`")
  newline.gsub!("&gt;","`>`")

  result << newline

end

if output
  File.open(output, "w") { |f| f.write result.join("\n") }
  puts "Outputted parsed markdown to #{output}"
else 
  puts result.join("\n")
end

