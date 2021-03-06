module RODF
  class MasterPage
    def initialize(name, opts = {})
      @name, @layout = name, opts[:layout]
    end

    def xml
      Builder::XmlMarkup.new.tag! 'style:master-page', 'style:name' => @name, 'style:page-layout-name' => @layout
    end
  end
end
