# ————— USER-CONFIGURABLE variables —————
OWNER          ?= joj
LABEL          ?= com.$(OWNER).update-brewfile
SCRIPT_PATH    ?= $(HOME)/.dotfiles/brew/scripts/update-brewfile.sh
LOG_OUT        ?= /tmp/update-brewfile.log
LOG_ERR        ?= /tmp/update-brewfile.err

WEEKDAY        ?= 2       # Monday = 2
HOUR           ?= 7       # 7 AM
MINUTE         ?= 0       # 00 minutes

LAUNCHDIR      := $(HOME)/Library/LaunchAgents
PLIST          := $(LAUNCHDIR)/$(LABEL).plist

TEMPLATE       := templates/update-brewfile.plist.in

# ————— RULES —————

.PHONY: install uninstall
install: $(PLIST)
	@echo "👉 Loading $(PLIST)"
	@launchctl unload $(PLIST) 2>/dev/null || true
	@launchctl load   $(PLIST)

uninstall:
	@echo "👉 Unloading & removing $(PLIST)"
	@launchctl unload $(PLIST) 2>/dev/null || true
	@rm -f $(PLIST)

$(PLIST): $(TEMPLATE)
	@mkdir -p $(LAUNCHDIR)
	@echo "👉 Generating $@ from template"
	@sed \
	  -e "s|@LABEL@|$(LABEL)|g" \
	  -e "s|@SCRIPT_PATH@|$(SCRIPT_PATH)|g" \
	  -e "s|@LOG_OUT@|$(LOG_OUT)|g" \
	  -e "s|@LOG_ERR@|$(LOG_ERR)|g" \
	  -e "s|@WEEKDAY@|$(WEEKDAY)|g" \
	  -e "s|@HOUR@|$(HOUR)|g" \
	  -e "s|@MINUTE@|$(MINUTE)|g" \
	  $< > $@

.PHONY: status
status:
	@echo "🔍 Listing all your com.$(OWNER).* agents:"
	@launchctl list | grep com.$(OWNER) || echo "  (none found)"
	@echo
	@echo "🔍 Details for your update-brewfile job:"
	@launchctl list $(LABEL) || echo "  (not loaded)"
