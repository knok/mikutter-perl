# -*- coding: utf-8 -*-

require 'dl'
require 'dl/import'
require 'dl/struct'
require 'pp'

module Perl
  extend DL::Importer
#  dlload "perlstub.so"
  dlload Environment::CONFROOT + "/plugin/mikutter-perl/perlstub.so"
  extern "void init_perl()"
  extern "const char* eval_perl(char *)"
  extern "void free_perl()"
end

Plugin.create(:mikutter_perl) do

  Perl::init_perl

#  notice "mikutter-perl"

  filter_before_postbox_post do |m|
    if m.include?("#perl")
      str = m.gsub("#perl", "")
      ret = Perl::evel_perl(str)
#      activity :system, str
      print ret, "\n"
    end
  end

end
