#!/usr/bin/env bash

usage() {
	message="${1}"

	(( ${#message} )) && echo "${message}"

	echo "
usage: $(basename $0) --server-name SERVERNAME [--image IMAGE] [--uid UID] [--port PORT] [--java-ops JAVAOPS]
"
}

run-server() {
    docker_image="${1}"
    server_name="${2}"
    user_uid="${3}"
    user_gid="${4}"
    port="${5}"
    java_opt="${6}"

    server_path="${HOME}/minecraft/${server_name}"
    [[ ! -d "${server_path}" ]] && echo "path '${server_path}' does not point to a directory" && exit 1

    web_port="80$(( port % 100 ))"
    docker run -d \
        --restart=always \
        --user="${user_uid}:${user_gid}" \
        --name "${server_name}" \
        --volume ${server_path}:/mc-server \
        --volume /etc/passwd:/etc/passwd:ro \
        --volume /etc/group:/etc/group:ro \
        -p ${port}:25565/tcp \
        -p ${port}:25565/udp \
        -p ${web_port}:8123/tcp \
        "${docker_image}" \
        --workdir /mc-server \
        --java-ops "${java_ops}"
}

main() {
	docker_image="mc:latest"
	user_uid=$(id -u)
	user_gid=$(id -g)
	port=25565
	java_ops="-Xmx2G"

	while (( ${#})); do
		case "${1}" in
			--image)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				docker_image="${1}"
				;;
			--uid)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				user_uid="${1}"
				;;
            --guid)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				user_gid="${1}"
				;;
			--server-name)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				server_name="${1}"
				;;
			--port)
				(( ${#} < 2 )) && usage "option '${1}' takes an argument" && exit 1
				shift
				port="${1}"
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

	(( ${#server_name} == 0 )) && usage "Must supply server_name" && exit 1
	
	run-server "${docker_image}" "${server_name}" "${user_uid}" "${user_gid}" "${port}" "${java_ops}"
}

main "${@}"
