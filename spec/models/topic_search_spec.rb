require 'rails_helper'

describe TopicSearch do
  it 'has a valid factory' do
    # Using the shortened version of FactoryGirl syntax.
    # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:topic_search)).to be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:factory_instance) { build(:topic_search) }

  describe '#result_stats' do\
    it 'works' do
      expect(factory_instance.result_stats).to eq(
        medline_plus_result: factory_instance.medline_plus_result?,
        guideline_gov_result: factory_instance.guideline_gov_result?,
        daily_med_result: factory_instance.daily_med_result?,
        fda_result: factory_instance.fda_result?
      )
    end
  end
end
