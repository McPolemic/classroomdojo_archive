#!/bin/sh

#curl 'https://home.classdojo.com/api/storyFeed?includePrivate=true' \
curl 'https://home.classdojo.com/api/storyFeed?before=2016-01-10T15%3A22%3A27.716Z&includePrivate=true' \
-XGET \
-H 'Referer: https://home.classdojo.com/' \
-H 'Content-Type: application/json' \
-H 'Host: home.classdojo.com' \
-H 'Accept: application/json' \
-H 'Connection: keep-alive' \
-H 'Accept-Language: en-us' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7' \
-H 'Cookie: amplitude_idclassdojo.com=eyJkZXZpY2VJZCI6IjA2ZTQ4ODc3LWM5MWItNGI0Ni05YzIyLTUzNDQ1NjA4YmNlMFIiLCJ1c2VySWQiOiI1OWNhZGUwNTZiMTY2ODE3NmMzY2VkMDEiLCJvcHRPdXQiOmZhbHNlLCJzZXNzaW9uSWQiOjE1MTY5OTAxNjU5MzgsImxhc3RFdmVudFRpbWUiOjE1MTY5OTA1NjA0MjUsImV2ZW50SWQiOjYsImlkZW50aWZ5SWQiOjksInNlcXVlbmNlTnVtYmVyIjoxNX0=; _ga=GA1.2.2115383455.1506543835; _gid=GA1.2.1248711454.1516990163; dojo_home_login.sid=s:dk8kiFVEk_6ItnI1AVYXc2aEl9uirgGN.7/yCXwSumelxHM/TFy0CsJzbokC+lnszQiWMtwJv9Zk; i18next=en; __insp_norec_sess=true; __insp_nv=true; __insp_slim=1516809853980; __insp_targlpt=Q2xhc3NEb2pv; __insp_targlpu=aHR0cHM6Ly93d3cuY2xhc3Nkb2pvLmNvbS8%3D; __insp_wid=599651065; dojo_login.sid=s%3Adk8kiFVEk_6ItnI1AVYXc2aEl9uirgGN.7%2FyCXwSumelxHM%2FTFy0CsJzbokC%2BlnszQiWMtwJv9Zk' | jq '.'
