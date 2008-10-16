# Affiliate XML Schema

## The official XML Schema to be followed is:
	
	::xml::
	<affiliate>
	
		<company>
			<name>Company Name</name>
			<logo>URL to Company Logo</logo>
			<description>Company Description</description>
			<email>Company's contact email address</email>
			<timestamp>A timestamp of when this XML document was created.</timestamp>
		</company>
		
		<product>
			<material_id>The Material ID of the product</material_id>
			<vendor>The Product Vendor</vendor>
			<year>The Product Year</year>
			<price type="(dollars|euro|yen)">Product Price</price>
			<availability>In Stock | Limited | Not in Stock</availability>
			<landing>The full URL Landing Page when User clicks on your link for this product</landing>
		</product>
	
	</affiliate>
	
## UTF-8 Compliant

XML needs to be UTF-8 compliant in order to be able to be properly parsed. For example, a Vendor name: "A & A Vendor" is not UTF-8 compliant and will throw errors in browsers that try to parse the data, such as FireFox. Here is how you would make it UTF-8 compliant:

	A &amp; A Vendor

The "&amp;" is an HTML entity, which modern day browsers support and understand. For a list of common XHTML/XML/HTML entities, view this page:

* http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references

To read the W3C Documenation: 

http://www.w3.org/International/questions/qa-escapes
http://www.w3.org/TR/REC-xml/