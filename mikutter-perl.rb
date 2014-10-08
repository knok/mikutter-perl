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

  filter_posted do |service, msgs|
    msgs.each do |m|
      #pp m
      if m.to_s.include?("#perl")
        begin
          str = m.to_s.gsub("#perl", "")
          ret = Perl::eval_perl(str)
          activity :system, ret.to_s
        rescue => e
          print "exception\n"
          pp e
        end
      end
    end
    [msgs]
  end

end
