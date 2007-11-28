#!/usr/bin/env ruby

RAILS_ROOT = File.dirname(__FILE__) + "/../../" unless defined?(RAILS_ROOT)
require 'optparse'
require 'yaml'

require File.dirname(__FILE__) + "/extensions"
require File.dirname(__FILE__) + "/shared"

require File.dirname(__FILE__) + "/backup/errors"
require File.dirname(__FILE__) + "/backup/runner"
require File.dirname(__FILE__) + "/backup/option_parser"
require File.dirname(__FILE__) + "/backup/version"


# TODO: This should be done in the command line tool:
# MysqlUtilities::Backup::OptionParser.parse
