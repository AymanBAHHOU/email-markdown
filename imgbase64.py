
import re
import os 
import base64
import sys 

def embed_image(images_folder, match):
    image_path = os.path.join(images_folder, os.path.basename(match.group(2)))
    
    with open(image_path, 'rb') as image_file:
        base64_image = base64.b64encode(image_file.read()).decode('utf-8')
    return f'<img src="data:image/png;base64,{base64_image}" alt="{match.group(1)}" /><br>'

# Replace the images with the base64 format
def getHTML(images_folder, html):
    image_regex = r'<img alt="([^"]+)" src="([^"]+)" />'
    html_content = re.sub(image_regex, lambda match: embed_image(images_folder, match), html)
    return html_content


# Replace the images with the base64 format
def getHTMLPath(images_folder, path):
    # Read the markdown file
    with open(path, 'r', encoding='utf-8') as file:
        content = file.read()
    image_regex = r'<img alt="([^"]+)" src="([^"]+)" />'
    html_content = re.sub(image_regex, lambda match: embed_image(images_folder, match), content)
    print(html_content)
    return html_content


args = sys.argv[1:]
if os.path.isfile(args[1]):
    getHTMLPath(args[0], args[1])
else:
    getHTML(args[0], args[1])
 
    
 
    