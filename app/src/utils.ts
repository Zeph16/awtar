export function getTimeAgo(date: Date | string | number) {
  if (!date) return "";

  const parsedDate = new Date(date);
  if (isNaN(parsedDate.getTime())) return "";

  const now = new Date();
  const diff = now.getTime() - parsedDate.getTime();

  if (diff < 10000) return "";

  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  if (days > 0) {
    return days === 1 ? "1 day ago" : `${days} days ago`;
  } else if (hours > 0) {
    return hours === 1 ? "1 hour ago" : `${hours} hours ago`;
  } else if (minutes > 0) {
    return minutes === 1 ? "1 minute ago" : `${minutes} minutes ago`;
  } else {
    return seconds === 1 ? "1 second ago" : `${seconds} seconds ago`;
  }
}

export function markdownToHtml(text: string): string {
  let parsed = text;
  parsed = parsed.replace(/^###### (.*)/gm, '<h6>$1</h6>')
  parsed = parsed.replace(/^##### (.*)/gm, '<h5>$1</h5>')
  parsed = parsed.replace(/^#### (.*)/gm, '<h4>$1</h4>')
  parsed = parsed.replace(/^### (.*)/gm, '<h3>$1</h3>')
  parsed = parsed.replace(/^## (.*)/gm, '<h2>$1</h2>')
  parsed = parsed.replace(/^# (.*)/gm, '<h1>$1</h1>')
  parsed = parsed.replace(/\!\[(.*?)\]\((.*?)\)/g, '<img src="$2">$1</a>')
  parsed = parsed.replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2" target="_blank">$1</a>')
  parsed = parsed.replace(/\*\*(.*?)\*\*/g, '<b>$1</b>')
  parsed = parsed.replace(/\*(.*?)\*/g, '<i>$1</i>')
  parsed = parsed.replace(/_(.*?)_/g, '<sub>$1</sub>')
  parsed = parsed.replace(/~(.*?)~/g, '<del>$1</del>')
  parsed = parsed.replace(/\^(.*?)\^/g, '<sup>$1</sup>')
  parsed = parsed.replace(/`(.*?)`/g, '<code>$1</code>')
  
  return parsed;
}
export function stripHtml(text: string) {
  return text.replace(/<[^>]*>/g, '');
}
export function randomUserImage() {
  const images = [
    'http://localhost:8000/images/profile1.jpg',
    'http://localhost:8000/images/profile2.jpg',
    'http://localhost:8000/images/profile3.jpg',
    'http://localhost:8000/images/profile4.jpg',
    'http://localhost:8000/images/profile5.jpg',
    'http://localhost:8000/images/profile6.jpg',
  ];
  return images[Math.ceil(Math.random() * images.length) - 1];
}
export function randomBlogImage() {
  const images = [
    "http://localhost:8000/images/blog1.jpg",
    "http://localhost:8000/images/blog2.jpg",
    "http://localhost:8000/images/blog3.jpg",
    "http://localhost:8000/images/blog4.jpg",
    "http://localhost:8000/images/blog5.jpg",
    "http://localhost:8000/images/blog6.jpg",
  ];
  return images[Math.floor(Math.random() * images.length)];
}
