#!/bin/bash

# See: https://unix.stackexchange.com/questions/385023/firefox-reading-out-urls-of-opened-tabs-from-the-command-line/389360#389360

_firefox_tab_number() {
export opentabs=$(find ~/.mozilla/firefox*/*.default/sessionstore-backups/recovery.jsonlz4);
python3 <<< $'import os, json, lz4.block
f = open(os.environ["opentabs"], "rb")
magic = f.read(8)
jdata = json.loads(lz4.block.decompress(f.read()).decode("utf-8"))
f.close()
for win in jdata.get("windows"):
    print(win["selected"])'
}

_firefox_web_site() {
export opentabs=$(find ~/.mozilla/firefox*/*.default/sessionstore-backups/recovery.jsonlz4);
sed -n "$(_firefox_tab_number)p" <(python3 <<< $'import os, json, lz4.block
f = open(os.environ["opentabs"], "rb")
magic = f.read(8)
jdata = json.loads(lz4.block.decompress(f.read()).decode("utf-8"))
f.close()
for win in jdata.get("windows"):
    for tab in win.get("tabs"):
        i = tab.get("index") - 1
        print(tab.get("entries")[i].get("url"))')
}

_use_firefox() {
  [ -f ~/.mozilla/firefox*/*.default/sessionstore-backups/recovery.jsonlz4 ] && return 0 || return 1
}

if _use_firefox; then
  web_site() { _firefox_web_site; }
fi
