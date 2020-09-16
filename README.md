cidr-finder
========

## Overview 

A command line to retrieve CIDR info of a target during security engagements

## What is **cidr-finder** ?

It is rudimentary bash script which acts a wrapper around https://api.bgpview.io to retrieve only CIDR info of a target.
CIDR refers to *Classless Inter-Domain Routing* which is a method for allocating IP addresses and for IP routing.

From this, one can identify IP Address scope of a target enabling them broaden their attack surfaces by mapping endpoints at those addresses.This is true
especially for large corporation who purchase an IP block from a _RIR(Regional Internet Registries)_.

## Why **cidr-finder** ?

During my engagements in order to get a good overview of my target,
i normally prefer to start with its IP Address scope and from there
map down domains, subdomains among other entities related to the target.


## **Dependencies**

You need to have _curl_ and _jq_ installed.

To install, use the package-manager provided in your system.
On most Linux distributions _curl_ is installed by default. By default _jq_ is not installed but present in the repository of your Distro 

*Debian & Ubuntu*

`sudo apt-get install curl jq`

*Arch*

`sudo pacman -S curl jq`


Installation
------------
```
git clone https://github.com/BabyBabaBabu/cidr-finder
cd cidr-finder
chmod +x cidr-finder.sh

```

Usage
-----

```
./cidr-finder [option] {parameter}

```

By default _cidr-finder_ saves output to a folder name `results/` within the script directory.

Options
-------

```
Options:
        -o <org name>   Query by Organization name.
        -d <domain>     Query by Domain
        -i <ip address> Query by IP Address
        -a <AS Number>  Query by ASN
        -h              Display this help message.

```

Examples
--------

```
Examples:
        ./cidr-finder.sh -o hackerone
        ./cidr-finder.sh -d hackerone.com
        ./cidr-finder.sh -i 104.16.99.52
        ./cidr-finder.sh -a AS15169

```

Special Thanks to [BGPView](https://bgpview.io/) for exposing their [API](https://api.bgpview.io) to the public for free.



