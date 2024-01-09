#!/usr/bin/env -S jq -nrf

now | [strftime("%Y", "%F")] as [ $year, $date ]
  | $name / "" | first |= ascii_upcase | add | . as $Name
  | gsub("-"; " ") as $title
  | "\($year)/\($date)-\($name)" as $dir
  | "\($dir)/\($name).md" as $file
  |
"---
title: \($title)
date: \($date)
tags: [ ]
---

[\($Name)]:
    ../../\($file)
    \"sibling file\"

<!-- Related -->

<!-- Repos -->

<!-- markdown-toc-generate-toc -->
<!-- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1036359 -->
<!-- < README.md pandoc -f gfm -t gfm --toc --template ../../lib/toc.md --columns=132 -->
<!-- **Table of Contents** -->

# See also

# This day

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::" as $txt
  |
"mkdir -p \($dir)
echo \($txt | @sh) > \($file)
ln -sf \($name).md \($dir)/README.md"
