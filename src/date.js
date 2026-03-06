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

document.querySelectorAll('.date').forEach(element => {
	element.innerText = time_since(element.innerText)
})
