<!--
---------------------------------------------------------------------
(C) 2014 - 2017 Eloi Carbo <eloicaso@openmailbox.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------
-->

`Work In Progress`

# LUCI Bird{4|6} v0.3 Packages Documentation
*  BIRD Daemon's original documentation: http://bird.network.cz/?get_doc
*  Extra documentation in English & Catalan: https://github.com/eloicaso/bgp-bmx6-bird-docn
*  If you want to add new options to bird*-openwrt packages add a pull request or issue in: https://github.com/eloicaso/bird-openwrt

> *Clarification*: This documentation covers luci-app-bird{4|6} as both are completely aligned and only those IPv4/6-specific options will be covered separately.

# Table of contents
1. [Status Page](#status)
2. [Log Page](#log)
3. [Overview Page](#overview)
4. [General Protocols Page](#general)


## Status Page <a name="status"></a>
The Status Page allows you to Start, Stop and restart the service as well as to check the result of these operations.

#### Components
- *Button* **Start**: Execute a Bird Daemon Service Start call. Operation's result is shown in the *Service Status* Text Box.
- *Button* **Stop**: Execute a Bird Daemon Service Stop call. Operation's result is shown in the *Service Status* Text Box.
- *Button* **Restart**: Execute a Bird Daemon Service Restart call. Operation's result is shown in the *Service Status* Text Box.
- *Text Box* **Service Status**: Executes a Bird Daemon Service Status call. Operation's result is shown as plain text.

#### Service Status common messages
* Running: Service is running with no issues
* Already started: You have clicked *Start* when the service was already running. No action taken.
* Stopped: You have clicked *Stop* when the service was running. Service has been stopped.
* Already stopped: You have clicked *Stop* when the service was already stopped. No action taken.
* Stopped ... Started: You have pressed *Restart* when the service was running. The service has been restarted.
* Already stopped .. Started: You have pressed *Restart* when the service was already stopped. The service has been started.
* Failed - *ERROR MESSAGE*: There is a configuration or validation issue that prevents Bird to start. Check the *Error Message* and the Log Page to debug it and fix it.

#### Error Examples
1. Validation issues:
  `bird4: Failed - bird: /tmp/bird4.conf, line 65: syntax error`

If we check the file shown: `/tmp/bird4.conf` :
```
protocol bgp BGPExample {
import Filter NonExistingFilter;
}
```
We have entered an invalid (non-existent in this case) filter name. In order to fix this, write the correct Filter Name or remove its reference from the BGP Protocol Configuration Page and start the service again.

2. Configuration issues:
  ` bird4: Failed - bird: /tmp/bird4.conf, line 76: Only internal neighbor can be RR client`

In this case, it is easy to spot that we have incorrectly selected the *Route Reflector Server* option incorrectly and we only need to untick it and start the service to solve it.

Usuarlly, any configuration issue will be flagged appropiately through Bird service messages. However, in the event where you do not have enough information, please look for advice in either Bird's documentation or in the affected Protocol's documentation.

## Log Page <a name="log"></a>
The Log Page shows the last 30 lines of the configured Bird Daemon Log file. This information is automatically refreshed each second.

#### Components
- *Text Area* **Log File**: 30 lines text area that shows the Log file information
- *Text* **Using Log File** and **File Size**: The first line of the Text Area is fixed and shows the file being used and its current size. **Please**, check this size information regularly to avoid letting the Log information overflow your Storage as it will make your service stop and prevent it to start until you fix it.
- *Text*: The next 30 lines show information about the events and debug information happening live. Main information are state changes and *info, warning, fatal or trace*. If you hit any issue starting the service, you can investigate the issue from this page.


## Overview Page <a name="overview"></a>
The Overview Page includes the configuration of basic Bird Daemon settings such as UCI usage, Routing Tables definition and Global Options.

### Bird File Settings (UCI Usage)
This section enables/disables the use of this package's capabilities.

#### Components
- *Check Box* **Use UCI configuration**:
  - If enabled, the package will use the UCI configuration generated by this web settings and translate it into a Bird Daemon configuration file.
  - If disabled, the package will do nothing and you will have to manually edit a Bird Daemon configuration file.
- *Text Box* **UCI File**: This file specifies the selected location for the translated Bird Daemon configuration file. Do not leave blank.

### Tables Configuration
This section allows you to set the Routing tables that will be used later in the different protocols. You can *Add* as many instances as required.

#### Components
- *Text Box* **Table Name**: Set an unique (meaningful) routing table name.
> In some instances or protocols, you may want or be required to set a specific ID to a Table. In order to do this, please, follow this -right now- [manual procedure](https://github.com/eloicaso/bgp-bmx6-bird-docn/blob/master/EN/manual_procedures.md).


### Global Options
This section allows you to configure basic Bird Daemon settings.

#### Components
- *Text Box* **Router ID**: Set the Identificator to be used in this Bird Daemon instance. This option must be:
> IPv4, this option will be set by default to the lowest IP Address configured. Otherwise, the identificator must be an IPv4 address.

> IPv6, this option is **mandatory** and must be a HEX value (Hexadecimal). This package (bird6-uci), provides the HEX value *0xCAFEBABE* as a default value to avoid initial crashes.

- *Text Box* **Log File**: Set the Name and Location of the Log file. By default, its location will be /tmp/bird{4|6}.log as the non-persistent partition.
- *Mutiple Value* **Log**: Set which elements you want Bird Daemon to log in the configured file.
> *Caution I*: if you select *All*, the other selected options will have no validity as, by definition, they are already included.
> *Caution II*: Take into consideration that the more elements Bird has to log, the more space you will require to store this log file. If your storage is full, Bird will fail to start until you free some space to store its Log data.

- *Multi Value* **Debug**: Set which Debug information elements you want Bird Daemon to log in the configured file.
> *Caution I*: if you select *All*, the other selected options will have no validity as, by definition, they are already included.
> *Caution II*: Take into consideration that the more elements Bird has to log, the more space you will require to store this log file (this is particularly critical in Debug as it can log MegaBytes of data quickly). If your storage is full, Bird will fail to start until you free some space to store its Log data.

## General Protocols <a name="general"></a>
The General Protocols Page includes the configuration of key OS Protocols or Network Basic Settings such as Kernel, Device or Static Routes.

### Kernel Options
This section allows you to set all the Kernel Protocols required to do Networking.
> The first Kernel instance is the Primary one and must be left by default for OS usage. Do not set its "Table" or "Kernel Table" options.

#### Components
- *Check Box* **Disabled**: Set this Check Box if you do not want to configure and use this Protocol.
- *List Value* **Table**: Select the Routing Table to be used in the Kernel Protocol instance.
> The Primary Kernel Protocol cannot be empty.

- *Text Box* **Import**: Set if the protocol must import routes and which ones.
  - *all*: Accept all the incoming routes.
  - *none*: Reject all the incoming routes.
  - *filter filterName*: Call an existing filter to define which incoming routes will be accepted or rejected.
- *Text Box* **Export**: Set if the protocol must export routes and which ones.
  - *all*: Accept all the outgoing routes.
  - *none*: Reject all the outgoing routes.
  - *filter filterName*: Call an existing filter to define which outgoing routes will be accepted or rejected.
- *Text Box* **Scan time**: Set the time between Kernel Routing Table scans. This value must be the same for all the Kernel Protocols.
- *Check Box* **Learn**: Set this option to allow the Kernel Protocol to learn Routes form other routing daemons or manually added by an admin.
- *Check Box* **Persist**: Set this option to store the routes learnt in the table until it is removed. Unset this option if you want to clean the routes on the fly.
- *Text Box* **Kernel Table**: Select the specific exitisting Routing Table for this Protocol instance.
> The Kernel Table ID must be previously set by the administrator during the Routing Table configuration. Currently (v0.3), this process is done manually. Please, follow this [manual procedure](https://github.com/eloicaso/bgp-bmx6-bird-docn/blob/master/EN/manual_procedures.md).

### Device Options
This section allows you to set all the Device *Protocol*. The Device *Protocol* is just a mechanism to bound the interfaces and Kernel tables in order to get its information.

#### Components
- *Check Box* **Disabled**: Set this Check Box if you do not want to configure and use this Protocol.
- *Text Box* **Scan Time**: Set the time between Kernel Routing Table scans. This value must be the same for all the Kernel Protocols.

### Static Options
This section allows you to create the container for Routes definition. Static protocol instances allows you to manually create Routes that Bird will use and which Routing Table should hold this information. It also helps to manage routes by marking them (i.e. *Unreachable*, *Blocked*, ...).

#### Components
- *Check Box* **Disabled**: Set this Check Box if you do not want to configure and use this Protocol.
- *List Value* **Table**: Select the Routing Table to be used in the Static Protocol instance.

### Routes
This section allows to set which Routes will be set in a specific Static Protocol and how these should be handled.

#### Components
- *List Value* **Route Instance**: Set which Static Protocol instance will contain this route infromation.
> Routes require an existing Static Protocol as parent.

- *Text Box* **Route Prefix**: Set the Route instance to be defined.
> Examples of routes are:. 10.0.0.0/8 (IPv4) or 2001:DB8:3000:0/16 (IPv6)

- *List Value* **Type Of Route**: This value will set the conditional settings. Options are:
  - **Router**: Classic routes going through specific IP Addresses. 
    - *Text Box* **Via**: Set the target IP Address to be used for Routing
    > I.e. 10.0.0.0/8 via 10.1.1.1
    
  - **MultiPath**: Multiple paths Route.
    - *List of Text Box* **Via**: Set the target Route to be used for Routing. This option allows several instances of **Via** elements.
    > I.e. 10.0.0.0/8 via 10.1.1.1
    >            via 10.1.1.100
    >            via 10.1.1.200

  - **Special**: Special treated Route.
    - *Text Box* **Attribute**: Block special consideration of routes.
    > **unreachable**: Return route cannot be reached.
    > **prohibit**: Return route has been administratively blocked.
    > **blackhole**: Silently drop the route.

  - **Iface**: Classic routes going through specific interfaces.
    - *List Value* **Interface**: Select the target interface to route.

  - **Recursive**: Set a static recursive route. Its next hope will depen on the table's lookup for each target IP Address.

### Direct Protocol
This section allows to set which Routes will be set in a specific Static Protocol and how these should be handled.
