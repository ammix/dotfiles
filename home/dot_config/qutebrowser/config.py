# General
config.load_autoconfig()
c.auto_save.session = True
c.window.hide_decoration = True

# Theme
import theme
theme.setup(c, 'mocha', True)

# Search
c.url.searchengines = {
    'DEFAULT':  'https://duckduckgo.com/?ia=web&q={}',
    '!a':       'https://www.amazon.com/s?k={}',
    '!d':       'https://duckduckgo.com/?ia=web&q={}',
    '!gh':      'https://github.com/search?o=desc&q={}&s=stars',
    '!gist':    'https://gist.github.com/search?q={}',
    '!gi':      'https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1',
    '!m':       'https://www.google.com/maps/search/{}',
    '!r':       'https://www.reddit.com/search?q={}',
    '!w':       'https://en.wikipedia.org/wiki/{}',
    '!aw':      'https://wiki.archlinux.org/title/Special:Search/{}'
}
