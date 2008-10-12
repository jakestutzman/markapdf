# MarkaPDF

Initial thanks goes to the creator of Bookmaker: Carlos Brando.

Similar to the bookmaker, some methods and classes were carried over and extended,
while new ideas have been added.

MarkaPDF is an easy way to create PDF versions of books or documentation. The reason behind
building of this library, is I wanted an easy way to create PDF books of documentation of
Open Source Code and Client Projects. 

You can create either an HTML Book version or a PDF Book version. You can use either
markdown or textile for formatting your book.

## Syntax Highlighting

One of the focuses of building this, was to have code highlighting. I wanted to support
multiple languages in one book, for those of us who like to write about HTML, CSS and
JavaScript when it comes to Semantic Markup.

I also wanted to allow the use of CSS for the Code Highlighting, so you can "theme"
your book, if you want to. I've provided 21 different Stylesheets that will resemble
the syntax highlighting of the famous Textmate for OS X.

Let's look at how we setup code blocks for a specific language:

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

	require 'lib/html'
	book = HTML::Book.new('code_lang' => "ruby")
	book.create

When choosing what Stylesheet you'll want to use for highlighting, take a look in the 
book directory: book/layout/stylesheets/highlight/ and choose one. You'll need to add
it to the template file's (book/layout/template.html) head.

Also, you can add additional CSS to the HTML template to provide a more personalized
version of your book/documenation. The template.html file is a starter Template that 
you can customize for your own needs. Keep in mind that the template.html file needs
to keep the same filename because the HTML::Book creator will be looking for it to
add the Markdown/Textile files to.

## Creating an HTML Book

First thing you need to do is create some Chapters in book/layout/chapters/ directory.
Make sure to name your chapters, 001\_Title.markdown or 001\_Title.textile. Using the 001 
prefix will allow for proper ordering of your chapters.

Any CSS you add yourself (not the highlight CSS) should be placed in book/layout/stylesheets/
directory. When a PDF version is created, the parser runs through this directory
to include any CSS files it finds.

Just like the chapter naming, you'll need to do the same for the CSS files. This is so you
can have the CSS loaded in the proper order. e.g. Say you have a reset.css file that you want
loaded first to reset browser defaults.

*Currently, I do not have this bundled as a gem.
Until then, you can created an HTML version from the Terminal:

	require 'lib/html'
	book = HTML::Book.new('book_location' => "book/", 'bookname' => "MyBook", 'code_css' => "amy", 'code_lang' => "ruby")
	book.create

The hash is optional. If you do not pass in any arguments, just make sure to be above
the book root directory.

The newly created book will be located: book/output/


## Creating a PDF Book

This is no different than creating our HTML Book version. The reason is, we have to create
an HTML version first before we can create a PDF version.

	require 'lib/pdf'
	book = PDF::Book.new('book_location' => "book/", 'bookname' => "MyBook", 'code_css' => "amy", 'code_lang' => "ruby")
	book.create


## Current support

HTML::Book Support

PDF::Book Support

## Future

There is a specific bug that I am aware of:

* When you create a PDF book, the first page has an image placed in the upper left. 

Features that I like to include:

* Gemify this
* Image support
* Custom sidebar support
* I'd like to not have to add CSS to the header of the template, but instead make sure
  that my custom CSS is located in the stylesheet root folder which would automatically
  get included.
* I'd like to be able to pass less options into the system, but still have the same amount
  of control over how it looks and what's included. A smarter system would be nice.
* I'd like to be able to have this go through actual projects, reading the comments to create
  a PDF book that you can then hand over as documentation. 