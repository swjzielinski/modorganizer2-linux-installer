#!/usr/bin/env bash

download="$utils/download.sh"
extract="$utils/extract.sh"

jdk_url='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u312-b07/OpenJDK8U-jre_x64_windows_hotspot_8u312b07.zip'

mo2_url='https://github.com/ModOrganizer2/modorganizer/releases/download/v2.5.0/Mod.Organizer-2.5.0.7z'

winetricks_url='https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks'

downloaded_jdk="$downloads_cache/${jdk_url##*/}"
extracted_jdk="${downloaded_jdk%.*}"
downloaded_winetricks="$downloads_cache/winetricks"
executable_winetricks="$shared/winetricks"

downloaded_mo2="$downloads_cache/${mo2_url##*/}"
extracted_mo2="${downloaded_mo2%.*}"

downloaded_scriptextender=""
extracted_scriptextender=""

if [ -n "$game_scriptextender_url" ]; then
	downloaded_scriptextender="$downloads_cache/${game_nexusid}_${game_scriptextender_url##*/}"
	extracted_scriptextender="${downloaded_scriptextender%.*}"
fi

function purge_downloads_cache() {
	if [ -f "$downloaded_scriptextender" ]; then
		log_info "removing '$downloaded_scriptextender'"
		rm "$downloaded_scriptextender"

		if [ -d "$extracted_scriptextender" ]; then
			log_info "removing '$extracted_scriptextender'"
			rm -rf "$extracted_scriptextender"
		fi
	fi

	if [ -f "$downloaded_mo2" ]; then
		log_info "removing '$downloaded_mo2'"
		rm "$downloaded_mo2"

		if [ -d "$extracted_mo2" ]; then
			log_info "removing '$extracted_mo2'"
			rm -rf "$extracted_mo2"
		fi
	fi

	if [ -f "$downloaded_jdk" ]; then
		log_info "removing '$downloaded_jdk'"
		rm "$downloaded_jdk"

		if [ -d "$extracted_jdk" ]; then
			log_info "removing '$extracted_jdk'"
			rm -rf "$extracted_jdk"
		fi
	fi

	if [ -f "$downloaded_winetricks" ]; then
		log_info "removing '$downloaded_winetricks'"
		rm "$downloaded_winetricks"
	fi
}

if [ "$cache_enabled" == "0" ]; then
	purge_downloads_cache
fi

started_download_step=1

if [ ! -f "$downloaded_jdk" ]; then
	"$download" "$jdk_url" "$downloaded_jdk"
	mkdir "$extracted_jdk"
	"$extract" "$downloaded_jdk" "$extracted_jdk"
fi

if [ ! -f "$downloaded_mo2" ]; then
	"$download" "$mo2_url" "$downloaded_mo2"
	mkdir "$extracted_mo2"
	"$extract" "$downloaded_mo2" "$extracted_mo2"
fi

if [ ! -f "$downloaded_winetricks" ]; then
	"$download" "$winetricks_url" "$downloaded_winetricks"
fi
cp "$downloaded_winetricks" "$executable_winetricks"
chmod u+x "$executable_winetricks"

if [ -n "$downloaded_scriptextender" ] && [ ! -f "$downloaded_scriptextender" ]; then
	"$download" "$game_scriptextender_url" "$downloaded_scriptextender"
	mkdir "$extracted_scriptextender"
	"$extract" "$downloaded_scriptextender" "$extracted_scriptextender"
fi

