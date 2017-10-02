require "spec_helper"

RSpec.describe PgHub::Base do
  it "has a version number" do
    expect(PgHub::Base::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
