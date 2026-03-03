/**
 * This file formats all code elements with markdown style
 * elements, a quick rundown of whats supported
 
 Any word containing http or https will be converted to an 
 actual anchor.

 Any line containing 3 or more hyphens "---" will be converted
 to a <hr> seperator element.

 You can surround text in single asterisks to make it italic
 *like so*, and you can use double asterisks to make text bold
 **like this**.

 If you surround text in backticks '`' it will be run through 
 googles syntax hylighting engine. if you surround text in 
 three backticks this will also occur but in a non-inline format.

 If you have a url that is prefixed with a '!' it will be treated
 as an image where the url following the '!' will be used as the 
 source.

 If you prefix a line with a '#' the line will be surrounded in a
 mark tag.

 This is just as basic markdown generator its only made for small
 use cases like this semi-static webpage, use at your own risk.
 **/
document.querySelectorAll("code").forEach(element => 
  {
	// Markdown style **bold** and *italic*
	let content = element.innerHTML;
	let italic_count = 0;
	let bold_count   = 0;
	let block_count  = 0;
	let code_count   = 0;

	for (let i = 0; i < content.length; i++)
	  {
		let letter = content[i];

		// Bold **
		if (letter == '*' && content[i+1]  == '*'){
			letter = (!(bold_count % 2)) ? "<b>" : "</b>";
			bold_count++;
			content = content.slice(0, i) + letter + content.slice(i+=2);
		}

		// Italic *
		else if (letter == "*"){
			letter = (!(italic_count % 2)) ? "<i>" : "</i>";
			italic_count++;
			content = content.slice(0, i) + letter + content.slice(i+=1);
		}

		/* Code `
		else if (letter == "`" && content[i+1] != '`'){
			letter = (!(code_count % 2)) ? `<code class="prettyprint">` : "</code>";
			code_count++;
			content = content.slice(0, i) + letter + content.slice(i+=1);
		}*/
	  }

	// For each line
	let lines = content.split('\n'); 
	lines.forEach((line,line_index) => 
	  {

		// For each word
		let words = line.split(' ');
		words.forEach((word, word_index) => 
		  {

			// make all links actually clickable
			if (word.includes("http") && block_count %2 == 0 && code_count %2 == 0){
			  	
				console.log(word);
			  	// Make urls prefixed with an '!' be converted to images
				if (word.includes("!https://") || word.includes("!http://"))
					word = `<img src="${word.replace("!https://", "https://").replace("!http://","http://")}">`

				// Make urls converted to actual clickable anchors.
				else word = `<a target="_blank" href="${word}">${word}</a>`;

			// Convert unicode seperator into <hr> seperator
			} else if (word.includes("---") && block_count %2 == 0 && code_count %2 == 0)
			 	word = `<hr class="proj-hr">`

			// Convert code blocks
			else if (word.includes("```"))
			  {
				word = 
					(block_count % 2 == 0) 
					? `<div class="cont-prettyprint"><code class="prettyprint">`
					: `</code></div>`;
				block_count++;
			  }
			
			words[word_index] = word;
		  })

		line = words.join(' ') + '\n';
	  	if (line.startsWith("#"))
		  line = `<mark>${line}</mark>`

		lines[line_index] = line;
	  })


	// Write formatted HTML
	content = lines.join('');
	element.innerHTML = content;
  })

document.body.style.display = "block"
console.log ("Hire me!")
