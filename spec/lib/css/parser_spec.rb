require 'spec_helper'

module CSS
  describe Parser do
    context "parsing a CSS file" do
      let(:css) { Parser.new.parse(fixture('style.css')) }

      it "should provide access to individual rulesets by selector" do
        (css['body'].to_s.split(/;/) - 'color:#333333;background:black url(../images/background.jpg) fixed;margin:0;padding:5px'.split(/;/)).should == []
      end

      it "should provide access to individual properties" do
        css['body']['color'] == '#333'
      end

      it "should match all selectors" do
        css.selectors.should == ['body', '#logo', '#container', '#content', '#menu', '#menu ul', '#menu ul li', '#menu ul li a', '#menu ul li a:hover']
      end
    end

    context "A failing parse" do
      let(:error) do
        error = nil
        begin
          Parser.new.parse(fixture('failing.css'))
        rescue CSSError => e
          error = e
        end
        error
      end

      it "should raise an error" do
        error.should be_a(CSSError)
      end

      it "should return the line number of the failure" do
        error.line_number.should == 7
      end

      it "should return the character of the failure" do
        error.char.should == 7
      end

      it "should return the reason for the error" do
      end
    end

    context "Overwriting rules" do
      let(:css) { Parser.new.parse(fixture('overwriting.css')) }

      it "should only have a single paragraph selector" do
        css.selectors.should == ['p', 'h1', 'h2']
      end

      it "should have a paragraph with a border of 1px" do
        css['p'].border.size.should == '1px'
      end

      it "should have a header 1 with a bottom margin larger than the other margins" do
        css['h1'].margin.to_s.should == 'margin:3px 3px 1em'
      end

      it "should have a header 2 with the same padding all around" do
        css['h2'].padding.to_s.should == 'padding:3px'
      end
    end
  end
end
