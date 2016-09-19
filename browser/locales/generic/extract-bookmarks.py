# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import sys
import re
import codecs
try:
  from Mozilla.Parser import getParser
except ImportError:
  sys.exit('''extract-bookmarks needs compare-locales

Find that on http://pypi.python.org/pypi/compare-locales.
This script has been tested with version 0.6, and might work with future 
versions.''')

ll=re.compile('\.(title|a|dd|h[0-9])$')

p = getParser(sys.argv[1])
p.readFile(sys.argv[1])

template = '''#filter emptyLines

# LOCALIZATION NOTE: The 'en-US' strings in the URLs will be replaced with
# your locale code, and link to your translated pages as soon as they're 
# live.

#define bookmarks_title %s
#define bookmarks_heading %s

#define bookmarks_toolbarfolder %s
#define bookmarks_toolbarfolder_description %s

# LOCALIZATION NOTE (getting_started):
# link title for https://cyberfox.8pecxstudios.com/
#define getting_started Getting Started

# LOCALIZATION NOTE (Cyberfox_heading):
# Firefox links folder name
#define cyberfox_heading 8pecxstudios

# LOCALIZATION NOTE (Cyberfox_help):
# link title for https://8pecxstudios.com/Forums/viewforum.php?f=8
#define cyberfox_help Help and Tutorials

# LOCALIZATION NOTE (Cyberfox_update):
# link title for https://cyberfox.8pecxstudios.com#selection
#define cyberfox_update Stay up to date

# LOCALIZATION NOTE (Cyberfox_community):
# link title for https://8pecxstudios.com/Forums/index.php
#define cyberfox_community Get Involved

# LOCALIZATION NOTE (Cyberfox_about):
# link title for https://cyberfox.8pecxstudios.com/about-us
#define cyberfox_about About Us

# LOCALIZATION NOTE (Cyberfox_feedback):
# link title for browser feedback page
# link title for https://8pecxstudios.com/Forums/viewforum.php?f=9
#define cyberfox_feedback User Reviews

# LOCALIZATION NOTE (Cyberfox_notifications):
# link title for browser notifications page
# link title for https://cyberfox.8pecxstudios.com/notifications
#define cyberfox_notifications Notifications

#unfilter emptyLines'''

strings = tuple(e.val for e in p if ll.search(e.key))

print codecs.utf_8_encode(template % strings)[0]
