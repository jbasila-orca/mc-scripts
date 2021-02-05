#!/usr/bin/env bash

usage() {
	message="${1}"

	(( ${#message} )) && echo "
${message}"
	echo "
usage: $(basename $0) {--jar <serverJarFile>} [--workdir <workdir>] [--java-ops <javaOptions>]
"
}

start-mc-server() {
	workdir="${1}"
	jar_file="${2}"
	java_ops="${3}"

	cd "${workdir}"
	java ${java_ops} -jar ${jar_file} nogui

}

main() {
	workdir="."
	jar_file="server.jar"
	java_ops="-Xmx2G"

	while (( ${#} )); do
		case "${1}" in
			--workdir)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				workdir="${1}"
				;;
			--jar)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				jar_file="${1}"
				;;
			--java-ops)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				java_ops="${1}"
				;;
			*)
				usage "uknown argument: '${1}'"
				exit 1
				;;
		esac

		shift
	done

	start-mc-server "${workdir}" "${jar_file}" "${java_ops}"
}

main "${@}"
