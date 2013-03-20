#!/bin/sh
#
# @author Dennis Chen
#
# List all library dependencies for the executable files or the ones in the specified directories.
#

getlibs ()
{
	ldd $1 2>/dev/null | \
	awk '
		$1 !~ /^linux-gate\.so.*$/ && $2 == "=>" {
			if($3 ~ /^\(0x[0-9a-fA-F]+\)$/) {
				printf("missing:%s ", $1);
			} else {
				printf("%s ", $3);
			}
		}
		$2 ~ /^\(0x[0-9a-fA-F]+\)$/ {
			printf("%s ", $1);
		}
	'
}

listdeps ()
{
	found="";
	missing="";
	broken="";
	pending="$1 ";	#trailing space is a delimitor
	list=$2;
	first=1

	while [ ! -z "${pending}" ]; do
		target=${pending%% *};
		pending=${pending#* };
		pattern=" ?${target} ";

		if echo "${found}${missing}${broken}" | egrep -q "${pattern}"; then
			if [ ${first} -eq 1 ]; then
				first=0;
			fi
			continue;
		fi

		if echo ${target} | grep -q '^missing:'; then
			if [ ${first} -eq 1 ]; then
				first=0;
				continue;
			fi
			missing="${missing}${target} ";
			continue;
		fi

		if [ ! -e ${target} ]; then 
			if [ ${first} -eq 1 ]; then
				first=0;
				continue;
			fi
			missing="${missing}missing:${target} ";
			continue;
		fi

		if [ -L ${target} ]; then
			if [ ${first} -eq 1 ]; then
				first=0;
				continue;
			fi

			followup=$(readlink ${target});

			if [ -z "${followup}" ]; then
				broken="${broken}broken:${target} ";
			else
				found="${found}${target} ";

				case ${followup} in
					/*)
						pending="${pending}${followup} ";
						;;
					*)
						#relative path to absolute path
						pending="${pending}$(cd $(dirname "$(dirname ${target})/${followup}"); pwd)/$(basename ${followup}) ";
						;;
				esac
			fi
			continue;
		fi

		if [ ! -r ${target} ]; then
			if [ ${first} -eq 1 ]; then
				first=0;
				continue;
			fi
			broken="${broken}broken:${target} ";
			continue;
		fi

		if [ ${first} -eq 1 ]; then
			first=0;
		else
			found="${found}${target} ";
		fi

		pending="${pending}$(getlibs ${target})"
	done

	eval "echo -n \"${list}\"" | sed 's/ \+/\n/g'
}

help ()
{
cat <<EOF

$(basename $0) [<switches>] <target> [<target> ...]

switches:
	-f, --found	List existing library paths. 
	-m, --missing	List missing library paths.
	-b, --broken	List broken library paths.
	-h, --help	Show this screen.
	target		Executable files, shared library files, or
			the directories containing the former ones.

	$(basename $0) will try to list all library paths by default 
	unless any of the switch -f, -m, or -b is specified.

EOF
}

list_all=1
list_args="";
list_targets=""

if [ $# -gt 0 ]; then
	while [ ! -z "$1" ]; do
		case $1 in
			-f|--found)   list_all=0; list_args="${list_args}\${found}";   shift; ;;
			-m|--missing) list_all=0; list_args="${list_args}\${missing}"; shift; ;;
			-b|--broken)  list_all=0; list_args="${list_args}\${broken}";  shift; ;;
			-h|--help)    help; exit 0; ;;
			*)            list_targets="${list_targets} $1"; shift; ;;
		esac
	done
else
	help
	exit 0;
fi

if [ ${list_all} -eq 1 ]; then
	list_args="\${found}\${missing}\${broken}";
fi

for target in ${list_targets}; do
	if [ -d ${target} ]; then
		for f in $(find ${target} -type f -perm -110); do
			listdeps $f "${list_args}"
		done
	else
		listdeps ${target} "${list_args}"
	fi
done | sort -u

