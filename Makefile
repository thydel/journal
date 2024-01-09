#!/usr/bin/make -f

MAKEFLAGS += -Rr --warn-undefined-variables
SHELL != which bash
.SHELLFLAGS := -euo pipefail -c

.ONESHELL:
.DELETE_ON_ERROR:
.PHONY: phony
_WS := $(or ) $(or )
_comma := ,
_hash := \#
_dash := -
.RECIPEPREFIX := $(_WS)
.DEFAULT_GOAL := main

self := $(lastword $(MAKEFILE_LIST))
$(self):;

dirs := tmp
$(dirs):; mkdir -p $@

~ := new
$~: name ?= dummy
$~: $~ = ./$< --arg name $(name) | dash
$~: lib/skl.jq phony; $($@)

~ := list
$~: year != date +%Y
$~: find := find $(year) -name README.md -printf '[%T@, "%p"]\n'
$~: sort := jq -sr 'sort_by(first) | reverse | map(last)[]' | tee tmp/files
$~: yq := xargs -i yq '.file="{}"' -f extract {} -oj
$~: jq := jq -r '"- [\(.date / "T" | first) \(.title)](\(.file / "/" | .[:-1] | join("/")))"'
$~: $~ := $(find) | $(sort) | $(yq) | $(jq) > README.md
$~: phony | tmp; $($@)

~ := add
$~: last != < tmp/files jq -nRr 'input / "/" | .[:-1] | join("/")'
$~: git := git add $(last) README.md; git ci -m 'Adds $(last)'
$~: $~ := echo "$(git)"
$~: phony; @$($@)

main: phony new

# Local Variables:
# indent-tabs-mode: nil
# End:
