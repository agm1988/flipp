require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BoardGamesHelper. For example:
#
# describe BoardGamesHelper do
#   describe "string concat" do      expect(helper.entity_icon('EAST')).to eq("<i class=\"fa fa-bug fa-3x fa-rotate-90\"></i>")
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BoardGamesHelper, type: :helper do
  describe 'entity_icon' do
    specify do
      expect(helper.entity_icon('WEST')).to eq("<i class=\"fa fa-bug fa-3x fa-rotate-270\"></i>")
      expect(helper.entity_icon('EAST')).to eq("<i class=\"fa fa-bug fa-3x fa-rotate-90\"></i>")
      expect(helper.entity_icon('SOUTH')).to eq("<i class=\"fa fa-bug fa-3x fa-rotate-180\"></i>")
      expect(helper.entity_icon('NORTH')).to eq("<i class=\"fa fa-bug fa-3x fa-rotate-360\"></i>")
    end
  end
end
