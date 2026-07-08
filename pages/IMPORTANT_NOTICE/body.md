# Welcome
I have completly reworked the journal system, this new system works as follows; When a new post is created the current ISO time along with a prompted post title - is written into a post directory of the same name as the title. I use plate_md to parse prompted MD post content into a body.md file also contained within the post dir. In the post script, there is a function that then loads the body.html and .title into a index.html file in the same page, this and the .date is also reflected in the journal entries page. Now that posts have their own dir, I can include individual media and there's now no need for annoying object files containing post data. In the UNIX fashion, everything is a file.

## Markdown
plate_md is a tiny markdown parsing engine written in C. Here is a display of whats available within the current engine:
# H1
## H2
### H3

horizontal line:
---

**BOLD** *italic*
<br>
```
code block
goes here
```

