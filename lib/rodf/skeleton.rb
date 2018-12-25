# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'erb'

module RODF
  class Skeleton
    def manifest(document_type)
      ERB.new(template('manifest.xml.erb')).result(binding)
    end

    def styles
      template('styles.pxml')
    end
  private
    def template(fname)
      File.open(File.dirname(__FILE__) + '/skeleton/' + fname).read
    end
  end
end
