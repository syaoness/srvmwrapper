#!/bin/bash

MASTERWRAPPER="${BUILT_PRODUCTS_DIR}/scumm_w.app/Contents/"
TEMPDIR="${DERIVED_FILES_DIR}/temp"
DESTDIR="${SRCROOT}/ScummVMWrapperConfig/Resources/"

rm -rf "${TEMPDIR}"
mkdir -p "${TEMPDIR}"

# Gather MD5s
if [ ! -d "${MASTERWRAPPER}" ]; then
	exit 1
fi

cd "${MASTERWRAPPER}"

# Header
cat > "${TEMPDIR}/WrapperDesc.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Files</key>
	<dict>
		<key>ScummVMwrapperConfig.app</key>
		<dict>
			<key>Type</key>
			<string>Self</string>
			<key>Checksum</key>
			<string></string>
			<key>Permissions</key>
			<integer>509</integer>
		</dict>
EOF

# Directories
find ./ -type d | {
	while read line; do
		if [[ "${line}" =~ /saves$ ]]; then
			continue
		fi
		
		filename="$(echo "${line}" | sed 's:./:Contents:')"
		echo -e "\t\t<key>${filename}</key>\n\t\t<dict>" >> "${TEMPDIR}/WrapperDesc.plist"
		if [[ "${line}" =~ /game$ ]]; then
			echo -e "\t\t\t<key>Type</key>\n\t\t\t<string>Ignore</string>" >> "${TEMPDIR}/WrapperDesc.plist"
		else
			echo -e "\t\t\t<key>Type</key>\n\t\t\t<string>Dir</string>" >> "${TEMPDIR}/WrapperDesc.plist"
		fi
		echo -e "\t\t\t<key>Checksum</key>\n\t\t\t<string></string>" >> "${TEMPDIR}/WrapperDesc.plist"
		echo -e "\t\t\t<key>Permissions</key>\n\t\t\t<integer>509</integer>" >> "${TEMPDIR}/WrapperDesc.plist"
		echo -e "\t\t</dict>" >> "${TEMPDIR}/WrapperDesc.plist"
	done
}
# Files
find ./ -type f | {
	while read line; do
		if [[ "${line}" =~ \.(empty|dontdeletethis)$ ]]; then
			continue
		fi
		filename="$(echo "${line}" | sed 's:\./:Contents:')"
		echo -e "\t\t<key>${filename}</key>\n\t\t<dict>" >> "${TEMPDIR}/WrapperDesc.plist"
		if [[ "${line}" =~ (/Info.plist|\.icns)$ ]]; then
			echo -e "\t\t\t<key>Type</key>\n\t\t\t<string>Ignore</string>" >> "${TEMPDIR}/WrapperDesc.plist"
			echo -e "\t\t\t<key>Checksum</key>\n\t\t\t<string></string>" >> "${TEMPDIR}/WrapperDesc.plist"
		else
			echo -e "\t\t\t<key>Type</key>\n\t\t\t<string>File</string>" >> "${TEMPDIR}/WrapperDesc.plist"
			echo -e "\t\t\t<key>Checksum</key>\n\t\t\t<string>$(md5 -q "${line}")</string>" >> "${TEMPDIR}/WrapperDesc.plist"
		fi
		if [[ "${line}" =~ /MacOS/[^/]*$ ]]; then
			echo -e "\t\t\t<key>Permissions</key>\n\t\t\t<integer>509</integer>" >> "${TEMPDIR}/WrapperDesc.plist"
		else
			echo -e "\t\t\t<key>Permissions</key>\n\t\t\t<integer>436</integer>" >> "${TEMPDIR}/WrapperDesc.plist"
		fi
		echo -e "\t\t</dict>" >> "${TEMPDIR}/WrapperDesc.plist"
	done
}

cat >> "${TEMPDIR}/WrapperDesc.plist" << EOF
		<key>Contents/Resources/saves</key>
		<dict>
			<key>Type</key>
			<string>Ignore</string>
			<key>Checksum</key>
			<string></string>
			<key>Permissions</key>
			<integer>509</integer>
		</dict>
	</dict>
</dict>
</plist>
EOF

cd ..
zip -r WrapperData Contents
mv WrapperData.zip "${DESTDIR}"
mv "${TEMPDIR}/WrapperDesc.plist" "${DESTDIR}"

