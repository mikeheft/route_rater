RSpec.describe Rides::Commands::ComputeAmount do
  let(:duration) { "577s" }
  let(:distance_meters) { 3105 }
  subject { described_class.call(ride:) }

  describe "CSU to The Still" do
    let(:ride) { OpenStruct.new(duration:, distance_meters:) }
    it "computes the amount" do
      result = subject
      expect(result.format).to eq("$12.00")
    end
  end

  describe "Fort Collins to Denver" do
    let(:distance_meters) {  100_262.1 }
    let(:duration) { "3600s" }
    let(:ride) { OpenStruct.new(duration:, distance_meters:) }
    it "computes the amount" do
      result = subject
      expect(result.format).to eq("$105.46")
    end
  end
end
