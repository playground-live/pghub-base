require "spec_helper"

RSpec.describe SupportDeveloperGithub::Base do
  it "has a version number" do
    expect(SupportDeveloperGithub::Base::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
