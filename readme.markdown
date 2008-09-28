# MarkaPDF

MarkaPDF is an easy way to create PDF versions of books or documentation. The reason behind
building of this library, is I wanted an easy way to create PDF books of documentation of
Open Source Code and Client Projects. 

The first version will be a simple HTML Book renderer that includes Syntax Highlighting of
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

## Creating an HTML Book

First thing you need to do is create some Chapters in book/layout/chapters/ directory.
Make sure to name your chapters, 001_Title.markdown. Using the 001 prefix will allow
for proper ordering of your chapters.

In the book/layout/template.html, make sure to include your CSS so you can customize
the look of your book. Also, if you have code, make sure to include the CSS for it
as well, which is located in book/layout/stylesheets/highlight. 

Any CSS you add yourself (not the highlight CSS) should be placed in book/layout/stylesheets/
directory. When a PDF version is created, the parser runs through this directory
to include any CSS files it finds.

Currently, integrating Thor to use as our creator for HTML and PDF versions of our book.
Until then, you can created an HTML version from the Terminal:

	require 'lib/html'
	book = HTML::Book.new('book_location' => "book/", 'bookname' => "MyBook", 
												'code_css' => "amy", 'code_lang' => "ruby")
	book.create

The option hash is optional. If you do not pass in any arguments, just make sure to be above
the book root directory.

The newly created book will be located: book/output/


## Creating a PDF Book

This is no different than creating our HTML Book version. The reason is, we have to create
an HTML version first before we can create a PDF version.

	require 'lib/pdf'
	book = PDF::Book.new('book_location' => "book/", 'bookname' => "MyBook", 
												'code_css' => "amy", 'code_lang' => "ruby")
	book.create


## Current support

HTML::Book Support

PDF::Book Support

## Future

Once the PDF version is complete, I'll start looking into how I can have it parse through
actual code (project files) so that it can create documentation from comments within the
code base. Wouldn't it be awesome to write the code for the clients project, include
appropriate comments that explain what each method does, and have a parser run through
the project and turn your comments into documentation with the code as code blocks
that the documentation explains. All this in a PDF document that you can turn over at
any time. 

We have rdoc and yard, but can you seriously turn these over to non-technical clients
as your documentation of the code base? Not in my experience.
