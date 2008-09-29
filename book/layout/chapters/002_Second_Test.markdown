# Here is our Second Test

We are going to test our code blocks. First, HTML:

	::html::
	<div class="test">Here is my test code</div>

Here we will test some javascript, that does not include our special language specifier.

	$(".test").hide();
	
And some CSS code:

	::css::
	div.class{
		border: 1px solid #ccc;
		background-color: #eee;
	}


And lastly, some more javascript without our language specifier.

	$('div.test').text("Add some more text here");