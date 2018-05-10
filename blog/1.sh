# run bash
# /bin/sh


# dev run hugo server
hugo server -b http://localhost:1313 --bind=0.0.0.0


# generate static site
# hugo --baseUrl="http://localhost:1313"     # Generate static sites in the sample-site
# hugo --baseUrl="http://localhost:1313" -d /static-site     # You need to mount a directory to static-site first and then static sites will be generated in that directory