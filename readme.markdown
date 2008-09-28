# MarkaPDF

MarkaPDF is an easy way to create PDF versions of books or documentation. The reason behind
building of this library, is I wanted an easy way to create PDF books of documentation of
Open Source Code and Client Projects. 

The first version will be a simple HTML Book render that includes Syntax Highlighting of
code blocks. You can include multiple languages within one book by adding the language
name to the top of the code block, like so:

	::ruby::
	class Test
		def initialize(options={})
			@options = options
		end
	end

::ruby:: defines the language for the code block. The "::ruby::" will be stripped out of
the code block before syntax highlighting is applied.

If the book is all one language, you don't need to include the ::language:: for each code
block. When you instantiate the HTML::Book object, just pass in the language for the book
and that is what will be used throughout.

Within the book/layout/stylesheets/highlight/ are a bunch of CSS files for doing code
highlighting. You can add these to the book/layout/template.html HEAD part so that
when you create your HTML version of the book, you have the appropriate CSS file
included for Code Highlighting.

Also, you can add additional CSS to the HTML template to provide a more personalized
version of your book/documenation. The template.html file is a starter Template that 
you can customize for your own needs. Keep in mind that the template.html file needs
to keep the same filename because the HTML::Book creator will be looking for it to
add the Markdown files to.

## Current support

Currently, only HTML rendering of the book is supported. A PDF version is being worked on.

## Future

Once the PDF version is complete, I'll start looking into how I can have it parse through
actual code (project files) so that it can create documentation from comments within the
code base. Wouldn't it be awesome to write the code for the clients project, include
appropriate comments that explain what each method does, and have a parse run through
the project and turn your comments into documentation with the code as code blocks
that the documentation explains. All this in a PDF document that you can turn over at
any time. 
