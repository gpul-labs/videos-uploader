#!/bin/bash

ARCHIVE_URL="http://s3.us.archive.org"


PARAM_SUBJECT="open source;free software;Software Libre;"
PARAM_CREATOR="GPUL"

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


PARAM_FILENAME=$(basename "$PARAM_PATH")

exec curl --location --header 'x-amzauto-make-bucket:1' \
	--header 'x-archive-meta01-collection:opensource_movies' \
	--header 'x-archive-meta-mediatype:movies' \
	--header "x-archive-meta-title:$PARAM_TITLE" \
	--header "x-archive-meta-creator:$PARAM_CREATOR" \
	--header "x-archive-meta-date:$PARAM_DATE" \
	--header "x-archive-meta-subject:$PARAM_SUBJECT" \
	--upload-file "$PARAM_PATH" \
	"$ARCHIVE_URL"/gpul_$PARAM_URL/$PARAM_FILENAME


