GitHUb Plugin for Rbot
======================

Copyright 2011 James Turnbull <james@lovedthanlost.net>

Licensed: GPLv3

Requires
--------

Requires the following:

* octopi

Install
-------

1.  Copy into the Rbot plugins directory
2.  Add it to list of loaded Rbot plugins
3.  Restart Rbot

Usage
-----

1.  Configure a channel to be monitored:

    github.repomap:
    - "#channelname:github_user:github_repo"

2.  Ask the bot to provide you with information from GitHub
    
    `botname: #11`
    `botname: commit:SHA`

