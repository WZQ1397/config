set -o errexit
set -o pipefail
lsof +c 0 -n -P -u root \
	| awk '/inotify$/ { gsub(/[urw]$/,"",$4); print $1" "$2" "$4 }' \
	| while read name pid fd; do \
	exe="$(readlink -f /proc/$pid/exe || echo n/a)"; \
	fdinfo="/proc/$pid/fdinfo/$fd" ; \
	count="$(grep -c inotify "$fdinfo" || true)"; \
	echo "$name $exe $pid $fdinfo $count"; \
done
