require 'nypl_log_formatter'

Delayed::Worker.logger =  NyplLogFormatter.new(STDOUT)
