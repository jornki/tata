# The Amazing Template Assembler #
TATA is a simple ruby script to automate the process of assembling templates. What it does it basically taking a bunch of html template files and sticking them in one master html file properly wrapped with script tags.

## Usage ##
1. Open the tata.rb file and edit the two variables at the top where it says to do so
2. In your html template files add a comment on the first line `<!-- id=myTemplateId -->`
You'll need to create your own name for that id of course (replace "myTemplateId"). This id will be inserted in the generated script tag in the output file
3. Run the script using __ruby tata.rb__ with the optional parameters (see below)

### Parameters ###
- __"-w"__ : Will watch the templates, compiling them whenever they change
- __"-compressed"__ : Gives you compressed output (no newlines)

This will watch the template files and combine them into your html file using compressed output
`ruby tata.rb -w -compressed`

This will watch and combine into the html file, but not compress
`ruby tata.rb -w`

and so on...