document.body.style.display = "block"
console.log ("Hire me!")

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
});
