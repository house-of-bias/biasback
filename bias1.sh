#!/bin/sh

# Take an url, return a GeoJSON of retweets
# Requires twitter creds in ~/oc

url=$1

#url='http://www.aljazeera.com/indepth/opinion/2014/11/opec-age-climate-change-201411289461527196.html'

twurl="https://api.twitter.com/1.1/search/tweets.json?q=$url&count=70"

names=`curlicue -f ~/oc -- -s $twurl|\
	jq -r '.statuses|sort_by(.user.followers_count)|reverse|.[]|.user.location'|\
	sort -u|\
	sed '/^$/d'|\
	tr -d ';/'|\
	tr '\n' ';'`

curl -s "http://api.tiles.mapbox.com/v4/geocode/mapbox.places-v1/${names}.json?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IlhHVkZmaW8ifQ.hAMX5hSW-QnTeRCMAy9A8Q"|jq '{type: "FeatureCollection", features: [.[]|.features[0]|objects]}'
