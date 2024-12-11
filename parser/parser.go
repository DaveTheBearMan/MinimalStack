package parser

import "strings"

/*

	Goal of Parser is this:

	UbuntuXenial1604_i386

    Ubuntu
        \-> Xenial 1604_i386
*/

var (
	OperatingSystems        = []string{"Ubuntu", "Debian", "Rocky", "Win", "WinSrv", "Kali", "pfSense", "Fedora", "CentOS", "ArchLinux"}
	operatingSystemsVersion = make(map[string][]string)
)

func ParseName(os string) string {
	lowerOs := strings.ToLower(os)
	for _, name := range OperatingSystems {
		lowerName := strings.ToLower(name)
		if strings.HasPrefix(lowerOs, lowerName) {
			return name
		}
	}
	return ""
}

func InsertOperatingSystem(os string) {
	OperatingSystem := ParseName(os)

	if OperatingSystem != "" {
		// Cut out the operating system so we can select just the attached version.
		operatingSystemsVersion[OperatingSystem] = append(operatingSystemsVersion[OperatingSystem], os[len(OperatingSystem):])
	}
}

func GetVersionsForOperatingSystem(os string) []string {
	return operatingSystemsVersion[os]
}

func GetVersions() map[string][]string {
	return operatingSystemsVersion
}
