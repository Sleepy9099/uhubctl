#!/bin/sh
# Hardware-free checks of command line handling. Usage: tests/smoke.sh ./uhubctl
bin=${1:-./uhubctl}
fail=0

expect() { # expect <exit code> <stderr/stdout substring> <args...>
    want=$1; text=$2; shift 2
    out=$("$bin" "$@" 2>&1); rc=$?
    if [ "$rc" -ne "$want" ] || ! printf '%s' "$out" | grep -qF -- "$text"; then
        echo "FAIL: $bin $* -> rc=$rc, wanted rc=$want and '$text'. Output:"; echo "$out"
        fail=1
    else
        echo "ok: $*"
    fi
}

expect 0 "."               -v
expect 1 "--json"          -h
expect 1 "Invalid action"  -a bogus
expect 1 "Invalid repeat"  -r 0
expect 1 "Invalid delay"   -d -1
expect 1 "Invalid delay"   -d nan
expect 1 "Invalid wait"    -w 5x
expect 1 "Invalid level"   -L 99
expect 1 "Bad port spec"   -p 0
expect 1 "Bad port spec"   -p 3-1
expect 1 "Invalid command" extra
exit $fail
