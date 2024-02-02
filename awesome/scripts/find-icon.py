#!/usr/bin/env python3

import sys
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

icon = Gtk.IconTheme.get_default().lookup_icon(format(sys.argv[1]), 48, 0)
if icon:
    print(icon.get_filename())
else:
    print("not found")