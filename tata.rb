#!/usr/bin/env ruby

# The Amazing Template Assembler by Jørn Kinderås - 2012
# Takes a bunch of HTML files and assembles them into the
# html file of your choice. For more information see the README file

# SETTINGS [Edit thesem and yes they are relative]
$template_dir = "build/templates/"
$html_target_file = "build/index.html"
# END SETTING

def tata(watch, compressed=false)
  # validate that the template directory
  # and the html file actually exists
  if not File.directory? $template_dir
    abort($template_dir + " is not a valid directory")
  end
  if not File.exists? $html_target_file or not File.extname($html_target_file) == '.html'
    abort($html_target_file + ' is not a valid html file');
  end
  
  # make sure we have a valid directory path
  $template_dir += "/" if $template_dir[-1,1] != '/'
  
  # id pattern used for detecting a template file
  pattern = /<!-- id=(.+) -->/
  
  # Get the template files
  files = Array.new
  Dir.new($template_dir).entries.each { |n| files.push($template_dir + n) if File.extname(n) == '.html' }
  
  # Holder for the templates
  templates = "<!-- TEMPLATES -->\n"
  
  # File that where processed
  tplFiles = Array.new
  
  # Does any of the files have changes
  hasChanges = false
  
  # For each filename
  files.each do |f|
    # For each file
    File.open(f) do |file|
      templateText = ""
      tplDetected = false
      # For each line
      file.each_line do |line|
        
        # Test if this file is a valid template
        if line =~ pattern
          # A matching pattern was found
          tplDetected = true
          # Save the filenames for output
          tplFiles.push(file.path)
          # Grab the template id
          id = line.scan(pattern).to_s
          # Start to build the template
          templateText += '<script id="' + id + '" type="text/template">' + "\n"
          
          # Detect if file has changed
          if not $changed_files[file.path]
            # this is a new file
            hasChanges = true
          else
            if $changed_files[file.path] != file.mtime
              # the file has changed
              hasChanges = true
            end
          end
          # remember when this file was last modified
          $changed_files[file.path] = file.mtime
        else
          # add the rest of the template content
          if compressed
            templateText += line.strip
          else
            templateText += line
          end
        end # For each line end
      end
      # wrap up the template
      templateText += "\n</script>\n"
      
      # If this file is a template
      if tplDetected
        templates += templateText
      elsif $changed_files[file.path]
        # This file was a template but has
        # been removed, stop processing it
        $changed_files.delete(file.path)
        hasChanges = true
        puts "Removed " + file.path
      end
      
    end # For each file end
  end # For each filename end
  
  # warp up the templates
  templates += "<!-- TEMPLATES END -->\n"

  # Get the content of the index file
  html = File.readlines($html_target_file).to_s
  # Remove any previous templates
  html.slice!(/<!-- TEMPLATES -->(.|\n|\r)+<!-- TEMPLATES END -->/)
  # Just to be sure that old template code is gone
  html.slice!(/<script(.+)text\/template">(.|\n|\r)+<\/script>/)
  # Remove any extra newlines
  html.gsub!(/\n\n+/, "\n")
  
  # Remove any junk if all templates where removed
  templates = "" if templates.lines.count < 3

  # And insert the [new] templates
  index = html.index(/<\/[B|b][o|O][d|D][y|Y]>/)
  html.insert(index, templates)
  
  # If there wasn't any changes, go again (if watch is enabled)
  if not hasChanges and watch
    sleep(1)
    tata(watch, compressed)
  end
  
  # write the changes to the html file
  f = File.open($html_target_file, 'w')
  f.write(html)
  f.close
  
  # Tell the user what just happened
  puts "The following templates where added to " + $html_target_file
  puts tplFiles
  puts "\n"
  
  # If watch is enabled, go again
  if watch
    sleep(1)
    tata(watch, compressed)
  end
  
end # End of method


def init
  watch = false
  compress = false
  
  ARGV.each do |a|
  	case a
  	when '-w'
  		watch = true
  	when '-compressed'
  		compress = true
  	end
  end
  
  tata(watch, compress)
end

# Start the app
$changed_files = Hash.new
init