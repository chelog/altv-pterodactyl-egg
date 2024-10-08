TZ=${TZ:-UTC}
export TZ

cd /home/container || exit 1

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

if [ -z ${ALTV_UPDATE} ] || [ "${ALTV_UPDATE}" == "1" ]; then
	if [ -z $ALTV_BRANCH ]; then
		echo -e "ALTV_BRANCH is not set.\n"
		echo -e "Using 'release' branch.\n"
		ALTV_BRANCH=release
	else
		echo -e "alt:V branch set to '${ALTV_BRANCH}'"
	fi

	altv-pkg $ALTV_BRANCH --yes
	chmod +x altv-server
	chmod +x altv-crash-handler
fi

# Display the command we're running in the output, and then execute it with the env
# from the container itself.
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
# shellcheck disable=SC2086
exec env ${PARSED}
