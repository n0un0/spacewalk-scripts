- **getDebianAnnouncements.py** By https://github.com/rpasche This downloads all security announcements of debian from the current year and the year before and uses html2text to transform it to ascii text
- **parseUbuntu.py** parses https://lists.ubuntu.com/archives/ubuntu-security-announce/$DATE.txt.gz into an XML which can be read by errata-import.pl / errata-import.py
- **parseDebian.py** By https://github.com/rpasche the same as parseUbuntu.py, but parses all security announcements downloaded with getDebianAnnouncements.py and writes this to an XML file for later use with errata-import-debian.py
- **errata-import.pl** originally by Steve Meier http://cefs.steve-meier.de/ I just modified it slightly to work with Ubuntu USN.
- **errata-import.py** By https://github.com/pandujar Ported version of the previous one. Includes some enhancenments like date, author and better package processing. Its quite faster than the Perl version.
- **errata-import-debian.py** By https://github.com/rpasche This is the modified version of errata-import.py for Debian
- **errata.py** is the missing "action" for rhn_check so it can apply Errata. Copy it to /usr/share/rhn/actions 
Its just a copy of https://github.com/spacewalkproject/spacewalk/tree/master/client/rhel/yum-rhn-plugin/actions
- **spacewalk-errata.sh** is a Bash script which downloads the compressed security announces, calls parseUbuntu.py on them and finally calls errata-import.py to import the Errata. This script can be run as a Cronjob to automate things.
- **errataToSlack.py** reports all errata affecting at least one system to a Slack channel or group
- **getSystemUpdatesHistory.py** Lists all packages installed on a given node after a datetime or after X hours before now
If no datetime is given, packages installed in past 24h are listed.
- **import-old.sh** imports all errata from Jan 2012 to the month just before today when run; in effect provides constantly up-to-date ubuntu-errata.xml file
- **debianSync.py** Ported version of https://github.com/stevemeier/spacewalk-debian-sync . Its a drop-in replacement, meaning all arguments are the same

- **pre_invoke.py.patch - spacewalk.patch and debUtils.py.patch** use it for Debian clients. You need to generate keys before :  
\# gpg --gen-key  
Generate a key, answer :  
    4) RSA sign only  
     0 expires never  
     Real Name: Spacewalk, email, comment: For GPG signing APT repos
