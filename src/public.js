console.log ("Hire me!")

function time_since (date)
{
	const fmt = (time, ext) =>
		{return `${time} ${ext}${(time >= 1) ? "s" : ""}`}

	const old_date = new Date(date);
	let seconds = Math.floor((new Date() - old_date) / 1000)
	
	var interval = seconds / 31536000;
	if (interval > 1)
		return fmt(Math.floor(interval), "year");
	
	interval = seconds / 2592000;
	if (interval > 1)
		return fmt(Math.floor(interval),"month");
	
	interval = seconds / 86400;
	if (interval > 1)
		return fmt(Math.floor(interval),"day");
	
	interval = seconds / 3600;
	if (interval > 1)
		return fmt(Math.floor(interval), "hour");
	
	interval = seconds / 60;
	if (interval > 1)
		return fmt(Math.floor(interval), "minute");
	
	return fmt(Math.floor(seconds), "second");
}

document.addEventListener('DOMContentLoaded', () => {
	document.querySelectorAll('pre, code, .code, .highlight, .sourceCode').forEach(el => {
		const lines = el.textContent.split(/\r?\n/);
		
		let start = 0;
		while (start < lines.length && lines[start].trim() === '')
			start++;
		
		let end = lines.length - 1;
		while (end >= 0 && lines[end].trim() === '')
			end--;
		
		if (start <= end) {
			const cleaned = lines.slice(start, end + 1).join('\n');
			el.textContent = cleaned;
		} else el.textContent = '';
	});

	document.querySelectorAll("code").forEach(element => {
		let content = element.innerHTML;
		let italic_count = 0;
		let bold_bold    = 0;
		for (let i = 0; i < content.length; i++) {
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
		}

		// For each line
		let lines = content.split('\n');
		lines.forEach((line,line_index) => {
			// For each word
			let words = line.split(' ');
			words.forEach((word, word_index) => {
				if (word.includes("http"))
					word = `<a target="_blank" href="${word}">${word}</a>`;
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
	});

	// Format the dates of journals
	document.querySelectorAll('.date').forEach(element => {
		element.innerText = time_since(element.innerText)
	})

});
