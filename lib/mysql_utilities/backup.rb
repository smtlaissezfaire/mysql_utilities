#!/usr/bin/env ruby

RAILS_ROOT = File.dirname(__FILE__) + "/../../" unless defined?(RAILS_ROOT)
require 'optparse'
require 'yaml'

require File.dirname(__FILE__) + "/extensions"
require File.dirname(__FILE__) + "/backup/core_functionality"
require File.dirname(__FILE__) + "/backup/option_parser"

#MysqlUtilities::Backup::OptionParser.parse
