# Changelog

Bird{4|6}-openwrt v0.3
* Refreshed package and tested with Bird Daemon v1.6.3 and LEDE17.01
   * Applied standardized code style (i.e. ${variable} or $(_command_))
   * Added Filters and Functions folders (/etc/bird{4|6}/{filters|functions}) and created an upgrade path for v0.2 users
   * Fixed some bugs from v0.2 and align some properties to v1.6.3 API
   * Re-added Pipe and Direct protocol functions
   * Removed hardcoded references to Bird4/Bird6 (where possible) and unified scripts by using variables
   * Makefile enhancements applied (i.e. Preserve configuration on sysupgrade)
   * Aligned Bird4 and Bird6 code (OSPF Protocol will be targeted in future releases)
* Changes in UCI's config (/etc/config/bird{4|6})
  * Removed non-critical configuration used as an example in v0.2
  * Added mandatory parameter in bird6 (Router\_ID **0xCAFEBABE**)
* Changes in Service script (/etc/init.d/bird{4|6})
  * Detached UCI transformation functions into a separate script (bird{4|6}-lib.sh) to simplify init.d script and move forward possible future automated tests
  * Switched from service commands to background bird{4|6} binary calls:
     * Service calls were not returning exit code (unable to show status)
     * Service calls were not returning stdout/stderr (unable to show error info)
     * The usage of Bird binaries allows more fine-grained configuration (i.e. specifying the PID or LOG file) and to be ran in background
  * Added an error control system to improve customer's feedback and service management
  * Created a temporary Bird configuration backup (overwritten each *service start)
  * Added Status function to return Bird service's current state
  * Added _quiet_ service handling functions to execute _start/stop/restart/status_ functions with no Terminal highlighting (LUCI Web calls)
     * Functions are named "*service*\_quiet"
* Changes in LUCI scripts (Web Configuration Interface)
   * Updated controller scripts
      * Updated script and re-sorted
      * Added Status, Log, Filters and Functions pages
    * Status Page
      * Show Service Bird{4|6} _status_ text (using status\_quiet)
      * Show Service Bird{4|6} _start/restart/stop_ buttons (using \*\_quiet)
    * Log Page
      * Show configured Bird{4|6} Log file. Auto-refresh each second
    * Filters & Functions Page
      * Allow selecting a file under /etc/bird{4|6}/{filters OR functions}/ or create a new one using current Timestamp \["New File (path-timestamp)"\]
        * Caution: if you want to use a newly created file after saving it, you will need to select the "New file" element or refresh the page
      * Load selected File in a Text Box and allow editing it
      * Save changes in the file
    * Update and improve old scripts
      * Re-sorted properties to follow a meaningful order for each protocol
      * Aligned BGP Templates and BGP Instances properties
      * Redefined mandatory and optional properties in order to align with each protocol requirements (according to Birdv1.6.3)
      * Enhanced linked properties presentation
      * Added more detail in some prone-to-error properties (i.e. import/export filters)
