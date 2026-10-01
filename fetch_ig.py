import urllib.request
import re

try:
    url = 'https://www.picuki.com/profile/ishka.center'
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    html = urllib.request.urlopen(req).read().decode('utf-8')
    images = re.findall(r'<img[^>]+src=\"([^\"]+)\"[^>]+class=\"post-image\"', html)
    print("IMAGES:", images[:6])
except Exception as e:
    print("ERROR:", e)
