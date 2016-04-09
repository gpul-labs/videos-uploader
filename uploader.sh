#!/bin/bash

ARCHIVE_URL="http://s3.us.archive.org"


VIDEO_CODEC=
VIDEO_EXT=mkv


PARAM_CREATOR_DEFAULT="GPUL"
PARAM_SUBJECT_DEFAULT="open source;free software;Software Libre;"

PARAM_CREATOR=${PARAM_CREATOR:-$PARAM_CREATOR_DEFAULT}
PARAM_SUBJECT=${PARAM_SUBJECT:-$PARAM_SUBJECT_DEFAULT}

if [[ -z "$ARCHIVE_ACCESSKEY" ]]; then
	echo "You need an Internet Archive Access Key as the ARCHIVE_ACCESSKEY environment variable." >&2
	exit 1
fi

if [[ -z "$PARAM_TITLE" ]]; then
	echo "You need a title for the element." >&2
	exit 1
fi

if [[ -z "$PARAM_URL" ]]; then
	echo "You need an URL for the element." >&2
	exit 1
fi

if [[ -z "$PARAM_DATE" ]]; then
	echo "You need a date for the element." >&2
	exit 1
fi

if [[ -z "$PARAM_CREATOR" ]]; then
	echo "You need a creator for the element." >&2
	exit 1
fi

if [[ -z "$PARAM_SUBJECT" ]]; then
	echo "You need a subject." >&2
	exit 1
fi

if [[ -z "$1" ]]; then
	usage
else
	PARAM_FOLDER="$1"
	PARAM_PATH="$PARAM_FOLDER"/"$PARAM_URL"."$VIDEO_EXT"
fi

usage () {
	echo "Usage: $0 folder-to-MTS-files"
	echo
	echo "Environment variables:"
	echo "\tARCHIVE_ACCESSKEY: access key and secret to Archive.org upload"
	echo "\tPARAM_URL: the basename of the URL that the file should be accessible from"
	echo "\tPARAM_DATE: the date the item was recorded on"
	echo "\tPARAM_CREATOR: the creator (if not $PARAM_CREATOR_DEFAULT)"
	echo "\tPARAM_SUBJECT: the subject (if not $PARAM_SUBJECT_DEFAULT)"
}


PARAM_FILENAME=$(basename "$PARAM_PATH")

process_videos () {
	(cd "$PARAM_FOLDER" && cat *.MTS *.mts | ffmpeg -f mts -i - -vcodec libx264 -acodec copy -f mkv -)
}


upload_to_archive() {
	curl --location --header 'x-amzauto-make-bucket:1' \
		--header 'x-archive-meta01-collection:opensource_movies' \
		--header 'x-archive-meta-mediatype:movies' \
		--header "x-archive-meta-title:$PARAM_TITLE" \
		--header "x-archive-meta-creator:$PARAM_CREATOR" \
		--header "x-archive-meta-date:$PARAM_DATE" \
		--header "x-archive-meta-subject:$PARAM_SUBJECT" \
		--upload-file "$PARAM_PATH" \
		"$ARCHIVE_URL"/gpul_$PARAM_URL/$PARAM_FILENAME
}

process_videos | upload_to_archive


