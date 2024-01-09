---
title: Govc hot add
date: 2024-01-08
tags: [ govc ]
---

[Govc-hot-add]:
    ../../2024/2024-01-08-govc-hot-add/govc-hot-add.md
    "sibling file"

<!-- Related -->

<!-- Repos -->

<!-- markdown-toc-generate-toc -->
<!-- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1036359 -->
<!-- < README.md pandoc -f gfm -t gfm --toc --template ../../lib/toc.md --columns=132 -->
<!-- **Table of Contents** -->

-   [TL;DR](#tldr)
-   [List of VM HotAddEnabled](#list-of-vm-hotaddenabled)
-   [About `cpuHotRemoveEnabled`](#about-cpuhotremoveenabled)

# TL;DR

- No need to bother setting `cpuHotRemoveEnabled`
- Adding memory is definitely one way
- Adding CPU is `govc` one way, but we'll be able to kernel disable
  CPU cores

# List of VM HotAddEnabled

```bash
what=(name config.{{memory,cpu}HotAddEnabled,cpuHotRemoveEnabled})
collect () { govc object.collect -json -type m / ${what[@]}; }
extract () { jq -s 'map(.changeSet | map({ (.name / "." | last): .val }) | add)'; }
merge () { jq 'map({ (.name): del(.name) }) | add'; }
filter () { jq 'map_values(select(map(.) | any))'; }

collect | extract | merge | filter
```

# About `cpuHotRemoveEnabled`

- See [Hot remove cpu/ram from vm][] and [vSphere Hotplug Support (82568)][]

        You can't hot-remove memory, but you could set a limit to get it
        ballooned away, not that this is recommended.

        You can't remove vCPUs but you can offline them from the guest OS,
        as long as they are 100% idle they have a negligible* impact on
        the VM.

        P.S.
        There is a setting, vcpu.hotremove, it also used to be in the UI
        at some point in the past and some API docs still mention it. It
        was partially implemented for hosted, i.e. Workstation and Fusion
        but never finalized due to lacking guest support, i.e. right now
        it does nothing.

[Hot remove cpu/ram from vm]:
    https://communities.vmware.com/t5/vSphere-Hypervisor-Discussions/Hot-remove-cpu-ram-from-vm/td-p/530497
    "vmware.com"
    
[vSphere Hotplug Support (82568)]:
    https://kb.vmware.com/s/article/82568
    "vmware.com"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
