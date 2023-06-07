import markdown
import sys 
import imgbase64

# Set the encoding to utf-8
sys.stdout.reconfigure(encoding='utf-8')

# Read the console args
if len(sys.argv) < 3:
    exit(1)
markdown_file = sys.argv[1]
images_folder = sys.argv[2]

# Read the markdown file
with open(markdown_file, 'r', encoding='utf-8') as file:
    m_content = file.read()

# convert markdown to HTMl
html = markdown.markdown(m_content, extensions=['tables'])

html_content = imgbase64.getHTML(images_folder, html)

print(html_content)
