# The Amazing Template Assembler #
TATA is a simple ruby script to automate the process of assembling templates. What it does it basically taking a bunch of html template files and sticking them in one master html file properly wrapped with script tags.

## Usage ##
- Open the tata.rb file and edit the two variables at the top where it says to do so
- Run the script using _ruby tata.rb_ with the optional parameters (see below)

### Parameters ###
- "-w" : Will watch the templates, compiling them whenever they change
- "-compressed" : Gives you compressed output (no newlines)